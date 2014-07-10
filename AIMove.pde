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

static final int NO_EVAL = -100000;

static final int playerAI1 = -1;
static final int playerAI2 = 1;
// static final int playerAI = -1;

/****************************************************************************************************************/

boolean isAIPlayer( int aPlayer ) {
  if ( aPlayer ==  playerAI1 ) {
    return true;
  } else if ( aPlayer ==  playerAI2) {
    return true;
  }
  return false;
}

/****************************************************************************************************************/
/*****************                                                                                ***************/
/****************  Options                                                                                *******/
/****************  (store all options for handling in the AI                                              *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

public class Option extends Object {

  int color1, field1;
  int color2, field2;
  int eval;
  
  public Option( boolean isActual ) {
    if ( isActual ) {
      setOption( idxFail, 0, -1, -1 );
    } else {
      setOption( -1, -1, -1, -1 );
    }
  }
 
  public Option( int fcol, int fld ) {
    setOption( fcol, fld, -1, -1 );
  }
 
  public Option(  int fcol1, int fld1, int fcol2, int fld2  ) {
    setOption( fcol1, fld1, fcol2, fld2 );
  }
 

  public void setOption( int fcol1, int fld1, int fcol2, int fld2) {
    color1 = fcol1;
    field1 = fld1;
    color2 = fcol2;
    field2 = fld2;
    
    eval = NO_EVAL;
  }


  public boolean isFail() {
    return (color1 == idxFail);
  }

  public boolean isNone() {
    return (color1 == idxNone);
  }

  public boolean isFinal() {
    return (isFinal1() || isFinal2());
  }


  public boolean isFinal1() {
    return (field1 == 10);
  }

  public boolean isFinal2() {
    return (field2 == 10);
  }

  public boolean isDouble() {
    return (color2 != -1);
  }


  public String toString() {
    return toString( true );
  }

  public String toString(boolean withEval) {
    String ln;
    
    ln = str_f( color1,2) + ":" + str_f( field1,2);
    
    if ( isDouble() ) {
      ln = ln.concat( "  &  " + str_f( color2,2) + ":" + str_f( field2,2) );
    } else {
      ln = ln.concat( "     " + "     " );
    }
    if ( withEval ) {
      ln = ln.concat( "  = " +  str_f( eval, 4 )  );
    }
    return ln;
  }







} 
  
  
  
/****************************************************************************************************************/
/*****************                                                                                ***************/
/****************  Options                                                                                *******/
/****************  (store all options for handling in the AI                                              *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

public class AIMove extends Object {
    // ATTENTION: values must be converted to fields first depending on color row
    
    Option moves[];  
    int ctMoves;
    SData sd;
    Dice d;
    boolean isActual;


    public AIMove( SData anSd, Dice aD, boolean anActual ) {
      // calculate all possible options based on current sd and dices 
      moves = new Option[45];
      ctMoves = -1;
     
      sd = anSd;
      d = aD;
      isActual = anActual;
      
      calcMoves();
    }      


    /*********************** Calculate possible moves ***********************/
    public void calcMoves() {
      int dval;
      int fld, fld2;

      // First option is to set fail
      ctMoves++;
      moves[ctMoves] = new Option(isActual);
      
      // check the white dices
      dval = d.getOtherValue();
      for ( int i=0; i<idxRows; i++ ) {
        fld = calcField( i,  dval );
        if ( sd.allowSet( i, fld ) ) {
          // Othervalue (2 white dices) matches
          ctMoves++;
          moves[ctMoves] = new Option(i, fld);
          
          // check additional move
          if ( isActual ) {
            for ( int i2=0; i2<idxRows; i2++ ) {
              fld2 = calcField( i2,  d.getValue1( i2 )  );
              if ( sd.allowSet( i2, fld2, i, fld ) ) {
                  // w1-w2 UND w1-<i2>
                  ctMoves++;
                  moves[ctMoves] = new Option(i, fld, i2, fld2);
              }

              fld2 = calcField( i2,  d.getValue2( i2 )  );
              if ( sd.allowSet( i2, fld2, i, fld ) ) {
                  // w1-w2 UND w2-<i2>
                  ctMoves++;
                  moves[ctMoves] = new Option(i, fld, i2, fld2);
              }
            }
          }
        }
      }        

      // check additional move
      if ( isActual ) {
        for ( int i2=0; i2<idxRows; i2++ ) {
          fld2 = calcField( i2,  d.getValue1( i2 )  );
          if ( sd.allowSet( i2, fld2 ) ) {
              // w1-<i2>
              ctMoves++;
              moves[ctMoves] = new Option(i2, fld2);
          }

          fld2 = calcField( i2,  d.getValue2( i2 )  );
          if ( sd.allowSet( i2, fld2 ) ) {
              // w2-<i2>
              ctMoves++;
              moves[ctMoves] = new Option(i2, fld2);
          }
        }
      }
  
    }
    
    /*********************** Evaluate possible moves ***********************/
    public Option calcEvaluation( boolean algm1 ) {
      int bestMove; 
      int bestEval;
      int anEval;
      int actMove = 0;
      
      // start calc with first move

      println( "      MOVES : " + ctMoves+1 );

      // Calculate simple strategy
      
      bestMove = 0;
      if ( algm1 ) {
        bestEval = evalMove1( moves[actMove] );
      } else {
        bestEval = evalMove2( moves[actMove] );
      }
      println( "      " + moves[actMove].toString() );

      while ( actMove < ctMoves ) {
        actMove++;    
        if ( algm1 ) {
          anEval = evalMove1( moves[actMove] );
        } else {
          anEval = evalMove2( moves[actMove] );
        }
        println( "      " + moves[actMove].toString() );
        if ( anEval > bestEval ) {
          bestMove = actMove;
          bestEval = anEval;
        }
      }
      
     return moves[bestMove];
     }


    /************************+ easy strategy *********************/
    public int evalMove1( Option move ) {
      int ct, jump, remFlds, tmpEval;
      int eval = 0;

      if (  move.isFail() ) {
        eval = -20;
      } else if (  move.isNone() ) {
        eval = 0;
      } else {
        // calc (pts - jump^2) add special value for finalizing
        ct = sd.countMarks( move.color1 );
        if ( move.field1 == 10 ) {
          ct += (ct+1) * 2;
        }
        jump = move.field1 - sd.lastMark( move.color1 );
        if ( isActual ) {
          tmpEval = ( ct - ( jump * jump ) );
        } else {
          tmpEval = ( ct - ( jump * jump * jump ) );
        }      
        eval += tmpEval;
  
        // eval also remaining fields fi below 5
        if ( ct < 4 ) {
          if ( ( ! move.isDouble() ) || ( move.color1 != move.color2 ) ) { 
            remFlds = 11 - sd.lastMark( move.color1 );
        
            tmpEval = ( (remFlds / 2) - ( 4 - ct ) ) * 2;
  
            eval += tmpEval;
          }
        }
    
        if ( move.isDouble() ) { 
          // calc (pts - jump^2) add special value for finalizing
          ct = sd.countMarks( move.color2 );
          if ( move.field2 == 10 ) {
            ct += (ct+1) * 2;
          }
          jump = move.field2 - sd.lastMark( move.color2 );
          if ( isActual ) {
            tmpEval = ( ct - ( jump * jump ) );
          } else {
            tmpEval = ( ct - ( jump * jump * jump ) );
          }      
          
          eval += tmpEval;
          
          // eval also remaining fields fi below 5
          if ( ct < 4 ) {
            remFlds = 11 - sd.lastMark( move.color2 );
        
            tmpEval = ( (remFlds / 2) - ( 4 - ct ) ) * 2;
  
            eval += tmpEval;
          }
        }
      }
      
      move.eval = eval;
      return eval;

    }

    /************************+ easy strategy *********************/
    public int evalMove2( Option move ) {
      int ct, jump, remFlds, tmpEval;
      int eval = 0;

      if (  move.isFail() ) {
        eval = ( sd.getFail() + 1 ) * -10;
      } else if (  move.isNone() ) {
        eval = 0;
      } else {
        // calc (pts - jump^2) add special value for finalizing
        ct = sd.countMarks( move.color1 );
        if ( move.field1 == 10 ) {
          ct += (ct+1) * 2;
        } else if ( ct > 4 ) {
          ct+= 5;
        }
        jump = move.field1 - sd.lastMark( move.color1 ) - 1;
        if ( isActual ) {
          tmpEval = ( ct - ( jump * jump ) );
        } else {
          tmpEval = ( ct - ( jump * jump * jump ) );
        }      
        eval += tmpEval;
  
        // eval also remaining fields fi below 5
        if ( ct < 4 ) {
          if ( ( ! move.isDouble() ) || ( move.color1 != move.color2 ) ) { 
            remFlds = 11 - sd.lastMark( move.color1 );
        
            tmpEval = ( (remFlds / 2) - ( 4 - ct ) ) * 2;
  
            eval += tmpEval;
          }
        }
    
        if ( move.isDouble() ) { 
          // calc (pts - jump^2) add special value for finalizing
          ct = sd.countMarks( move.color2 );
          if ( move.field2 == 10 ) {
            ct += (ct+1) * 2;
          } else if ( ct > 4 ) {
            ct+= 5;
          }
          jump = move.field2 - sd.lastMark( move.color2 );
          if ( isActual ) {
            tmpEval = ( ct - ( jump * jump ) );
          } else {
            tmpEval = ( ct - ( jump * jump * jump ) );
          }      
          
          eval += tmpEval;
          
          // eval also remaining fields fi below 5
          if ( ct < 4 ) {
            remFlds = 11 - sd.lastMark( move.color2 );
        
            tmpEval = ( (remFlds / 2) - ( 4 - ct ) ) * 2;
  
            eval += tmpEval;
          }
        }
      }
      
      move.eval = eval;
      return eval;

    }



}
