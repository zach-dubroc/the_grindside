
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

rotate_tag := class(tag):
    


item_rotator := class(creative_device):
    # @editable var football_target :creative_prop = creative_prop{}
    # @editable var RotateYaw :logic = false
    # @editable var RotatePitch :logic = false
    # @editable var RotateRoll :logic = false
    @editable var Speed :float = 0.10
    
    OnBegin<override>()<suspends>:void=
        TagGenerator := FindCreativeObjectsWithTag(rotate_tag{})
        for (obj : TagGenerator):
            if (Prop := creative_prop[obj]):
                spawn:
                    SmoothRotate(Prop)

        
    
    RotateProp<private>(Prop: creative_prop)<suspends>:void=
        
        loop:
            Transform := Prop.GetTransform()
            Position := Transform.Translation
            Rotation := Transform.Rotation
            var NewRotation :rotation = Rotation    
            
            # if(RotateYaw = true, set NewRotation = NewRotation.ApplyYaw(Speed)){}
            # if(RotatePitch = true, set NewRotation = NewRotation.ApplyPitch(Speed)){}
            # if(RotateRoll = true, set NewRotation = NewRotation.ApplyRoll(Speed)){}
            
            if(Prop.TeleportTo[Position, NewRotation]){}
            
            Sleep(0.01)

        
    SmoothRotate<private>(Prop: creative_prop)<suspends>:void=
        Transform := Prop.GetTransform()
        Position := Transform.Translation
        Rotation := Transform.Rotation
        NewRotation := Rotation.ApplyYaw(180.0)
        MoveResult := Prop.MoveTo(Position, NewRotation, 3.0)
        if (MoveResult = move_to_result.DestinationReached):
            SmoothRotate(Prop) 
            