proc('_distanceBetween',@locA,@locB){

    return(sqrt(pow(@locA['x'] - @locB['x'], 2) + pow(@locA['y'] - @locB['y'], 2) + pow(@locA['z'] - @locB['z'], 2)))

}
