/************************************************************************************************
 *
 *  qdice
 *
 *  Copyright 2014 by Johannes Viegener
 *
 *  This file is part of qdice.
 *
 *  qdice is free software: you can redistribute it and/or modify
 *  it under the terms of the Lesser GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  qdice is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Lesser GNU General Public License
 *  along with qdice.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author     Johannes Viegener
 *
 *************************************************************************************************/  

/****************************************************************************************************************/
/*****************                                                                                ***************/
/****************  Dice                                                                                  *******/
/****************  (store data for the dices)                                               *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

static final int NUM_DICES = 6;

static final int DICE_W1 = 0;
static final int DICE_W2 = 1;
static final int DICE_R = 2;
static final int DICE_Y = 3;
static final int DICE_G = 4;
static final int DICE_B = 5;



public class Dice extends Object {
  public int w1, w2, r, g, b, y;
  
  public int rollADice() {
    return int(random( 0, 6 ))+1;
  }

  public void roll() {
    w1 = rollADice();
    w2 = rollADice();
    r =  rollADice();
    g =  rollADice();
    b =  rollADice();
    y =  rollADice();
  }


  public int getOtherValue() {
    return (w1 + w2);
  }

  public boolean isColorValue(int fcol, int dval) {
    int cold = 0;
    
    switch( fcol ) {
      case 0:
        cold = r;
        break;
      case 1:
        cold = y;
        break;
      case 2:
        cold = g;
        break;
      case 3:
        cold = b;
        break;
    }    
    return ( ( dval == (cold + w1) ) || ( dval == (cold + w2) ) );
  }


  public int getDiceValue( int dIdx ) {
    int val = -1;

    switch( dIdx ) {
      case DICE_W1:
        val = w1;
        break;
      case DICE_W2:
        val = w2;
        break;
      case DICE_R:
        val = r;
        break;
      case DICE_Y:
        val = y;
        break;
      case DICE_G:
        val = g;
        break;
      case DICE_B:
        val = b;
        break;
    }
    
    return val;
    
  }



}





