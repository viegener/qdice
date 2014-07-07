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

static final int playerAI = 1;
// static final int playerAI = -1;

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
    public Option calcEvaluation() {
      int bestMove; 
      int bestEval;
      int anEval;
      int actMove = 0;
      
      // start calc with first move

      // Calculate simple strategy
      
      bestMove = 0;
      bestEval = evalMove( moves[actMove] );
      actMove++;
      
      while ( actMove < ctMoves ) {
        actMove++;    
        anEval = evalMove( moves[actMove] );
        if ( anEval > bestEval ) {
          bestMove = actMove;
          bestEval = anEval;
        }
      }
      
      
     return moves[bestMove];
     }



    
    /************************+ easy strategy *********************/
    public int evalMove( Option move ) {
      if (  move.isFail() ) {
        return -20;
      }

      if (  move.isNone() ) {
        return 0;
      }
      
      return 10;

    }


}
