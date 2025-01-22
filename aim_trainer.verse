
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath}

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.


aim_trainer := class(creative_device):

    @editable var Prop :creative_prop = creative_prop{}
    @editable var MinimumPositions :vector3 = vector3{}
    @editable var MaximumPositions :vector3 = vector3{}
    @editable var PropManipulator :prop_manipulator_device = prop_manipulator_device{}
    @editable var ScoreBoard :billboard_device = billboard_device{}
    @editable var WeaponSpawner : item_spawner_device = item_spawner_device{}
    @editable var EndGame :end_game_device = end_game_device{}
    @editable var WinScore :float = 50.0


    ScoreText<localizes>(ScoreMessage :string): message = "Score: {ScoreMessage}"

    var TimeStamp :float = 0.0
    var Score :float = 0.0
    
    OnBegin<override>()<suspends>:void=
        PropManipulator.DamagedEvent.Subscribe(OnPropDamaged)
        WeaponSpawner.ItemPickedUpEvent.Subscribe(OnWeaponPickedUp)
        ScoreBoard.SetText(ScoreText("Score: {Score}"))


        
    
    OnWeaponPickedUp(Agent : agent) :void=
        spawn:
            ShowNextTarget(3.0)

    OnPropDamaged(Agent : agent):void=
        spawn:
            ShowNextTarget(0.1)
        UpdateScore()
        PropManipulator.HideProps() 
        
    UpdateScore():void=
        CurrentTime := GetSimulationElapsedTime()
        AttackSpeed := CurrentTime - TimeStamp



        var EarnedPoints :float = 1.0
        if (AttackSpeed <= 1.0):
            set EarnedPoints = 10.0
        else if (AttackSpeed <= 2.0):
            set EarnedPoints = 5.0
        else if (AttackSpeed <= 3.0):
            set EarnedPoints = 3.0

        set TimeStamp = CurrentTime

        # Print("Earned: {EarnedPoints}")
        set Score += EarnedPoints
        # Print("score: {Score}")
        ScoreText("Score: {Score}")
        ScoreBoard.SetText(ScoreText("Score: {Score}"))

        if (Score >= WinScore):
            AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers):
                if (Agent := agent[Player]):
                    EndGame.Activate(Agent)

    ShowNextTarget(Delay :float)<suspends>:void=

        Sleep(Delay)
        
        RandX := GetRandomFloat(MinimumPositions.X, MaximumPositions.X)
        RandY := GetRandomFloat(MinimumPositions.Y, MaximumPositions.Y)
        RandZ := GetRandomFloat(MinimumPositions.Z, MaximumPositions.Z)
        NewPosition := vector3{X:=RandX,Y:= RandY,Z:= RandZ}
        if (Prop.TeleportTo[NewPosition, Prop.GetTransform().Rotation]) {}
        PropManipulator.ShowProps()
        set TimeStamp = GetSimulationElapsedTime()

           
