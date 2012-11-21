Compass = require '../../models/compass'
assert = require('chai').assert

describe 'compass', ->

  it 'returns the compass direction from degrees true north', ->
    segments = [
      [0,'N']
      [30,'NNE']
      [45,'NE']
      [60,'ENE']
      [90,'E']
      [115,'ESE']
      [135,'SE']
      [160,'SSE']
      [180,'S']
      [200,'SSW']
      [225,'SW']
      [250,'WSW']
      [270,'W']
      [290,'WNW']
      [315,'NW']
      [340,'NNW']
    ]
    
    for segment in segments
      assert.equal Compass.directionFromDegrees(segment[0]), segment[1], "#{segment[0]}º is #{segment[1]}"
