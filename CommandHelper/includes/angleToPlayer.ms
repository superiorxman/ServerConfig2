proc('_angleToPlayer', @player, @target,
  # Get the location of the player and the target
  @playerLocation = ploc(@player)
  @victimLocation = ploc(@target)

  @dx = @playerLocation[0] - @victimLocation[0]
  @dz = @playerLocation[2] - @victimLocation[2]

  @angle = to_degrees(atan2(@dz,@dx))
  @facing = pfacing(@player)[0]

  @diff = round(@angle - @facing)

  @diff = @diff + 90
  if(@diff<-180) {
    @diff = @diff + 360
  }
  if(@diff>180) {
    @diff = @diff - 360
  }

  @distance = sqrt(@dx**2 + @dz**2)
  @dy = @playerLocation[1] - @victimLocation[1] + 2.62

  @angley = to_degrees(atan2(@dy,@distance))
  @facingy = pfacing(@player)[1]

  @diffy = round(@facingy - @angley)

  return(array(@diff, @diffy))
)