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

static final int numPlayer = 2;

static final int MAX_PLAYER = 4;

/*************************************************************************************************/

static final int MODE_NONE = 0;

static final int MODE_PLAYERA = 1;
static final int MODE_PLAYERB = 2;
static final int MODE_OTHER  = 3;
static final int MODE_NEXTPLAYER  = 4;


/*************************************************************************************************/

static final int AO_NONE = 0;
static final int AO_OTHER = 1;
static final int AO_PLAYER = 2;

static final String spaces = "                    ";  

/*************************************************************************************************/

public String str_f( int value, int len ) {
  String ret = str(value);
  
  if ( ret.length() >= len ) {
    return ret;
  }
  
  return String.valueOf(spaces.toCharArray(), 0, (len - ret.length() ) ) + ret;

}

/*************************************************************************************************/

SData playerSDs[];
int playerActual;
int playerOther;

Dice d = new Dice();

int gameMode = MODE_NONE;

int playerStore1Fld, playerStore1FCol;
boolean hasSetAField;

StringList protocol;
String protLine;


/*************************************************************************************************/

public void newGame() {
  playerSDs = new SData[numPlayer];

  for ( int i=0; i<numPlayer; i++ ) {
     playerSDs[i] = new SData("Player "+(i+1));
  }
  
  for ( int i=0; i<5; i++ ) {
    sDataEnd[i] = false;
  }
  
  protocol = new StringList();

  initScreenGame();

  for ( int i=0; i<numPlayer; i++ ) {
     showMiniForm( i, playerSDs[i], AO_NONE );
  }

  playerActual = -1;
  
  
}

/*************************************************************************************************/

public boolean newTurn() {
  playerActual++;
  if ( playerActual >= numPlayer ) {
    playerActual = 0;
  }   

  d.roll();
  showDice( d, true );
  
  protocol.append(  str( playerActual ) + "   Dice : " + d.toString() );
  println( protocol.get( protocol.size() - 1 ) );
  
  initForm( playerSDs[playerActual] );
  btnPlay.setCaptionLabel( "  Würfel-Spieler >" + (playerActual+1) +"<" );
  showMiniForm( playerActual, playerSDs[playerActual], AO_PLAYER );
  
  hasSetAField = false;

  playerOther = -1;
  
  protLine = "  P-" + str( playerActual ) + " > ";
  
  if ( isAIPlayer( playerActual ) ) {
    return makeAIMove( playerActual, playerSDs[playerActual] , d, true ); 
  } else {
    protLine = protLine.concat("                       ");
    // new turn is complete
    return true;
  }
}

/*************************************************************************************************/

public boolean newOther() {
  boolean isStepDone = false;
  
  if ( playerOther == -1 ) {
    updateSData( playerSDs[playerActual] );
    showMiniForm( playerActual, playerSDs[playerActual], AO_PLAYER );

    protLine = protLine.concat( "    >> " + playerSDs[playerActual].toString() );
    protocol.append( protLine );
    println( protLine );

    showDice( d, false );

  } else {
    updateSData( playerSDs[playerOther] );
    showMiniForm( playerOther, playerSDs[playerOther], AO_NONE );

    protLine = protLine.concat( "    >> " + playerSDs[playerOther].toString() );
    protocol.append( protLine );
    println( protLine );
  }

  playerOther++;
  if ( playerOther == playerActual ) {
    playerOther++;
  }

  if ( playerOther >= numPlayer ) {
// Needed??    showMiniForm( playerActual, playerSDs[playerActual], AO_NONE );

    // all players moved, so eval if any row is ended
    for ( int i=0; i<numPlayer; i++ ) {
       playerSDs[i].updateDataEnd();
    }

  } else {

    initForm( playerSDs[playerOther] );
    btnPlay.setCaptionLabel( "  Anderer Spieler >" + (playerOther+1) +"<" );
    showMiniForm( playerOther, playerSDs[playerOther], AO_OTHER );

    protLine = "  O-" + str( playerOther ) + " > ";

    if ( isAIPlayer( playerOther ) ) {
      isStepDone = ( makeAIMove( playerOther, playerSDs[playerOther] , d, false ) ); 
    } else {
      protLine = protLine.concat("                       ");
      isStepDone = true;
    }

  }

  return isStepDone;

}

/*************************************************************************************************/

public boolean endGame() {
  initScreenEnd();
  btnPlay.setCaptionLabel( " Neues Spiel " );

  return true;  
}


/*************************************************************************************************/


public boolean makeAIMove( int playerNum, SData sd, Dice d, boolean isActual ) { 
  AIMove ai = new AIMove( sd , d, isActual ); 

  Option move = ai.calcEvaluation( ( playerNum == playerAI1 ) );

  protLine = protLine.concat( str_f( move.color1,2) + ":" + str_f( move.field1,2) );
  if ( move.isDouble() ) {
    protLine = protLine.concat( "  &  " + str_f( move.color2,2) + ":" + str_f( move.field2,2) );
  } else {
    protLine = protLine.concat( "     " + "     " );
  }

  protLine = protLine.concat( "  = " +  str_f( move.eval, 4 )  );

  updateForm( move );
  
  if ( isActual ) {
//    print("BEST ACTUAL ");
    hasSetAField = true;
  } else {
//    print("BEST OTHER  ");
  }

/*
  print( move.color1 + ":" + move.field1 );
  if ( move.isDouble() ) {
    print( "   " + move.color2 + ":" + move.field2 );
  }
  println("   = " + move.eval );
*/

  // is never complete
  return false;
}


/*************************************************************************************************/
public void playNextStep() {
  boolean stepComplete = false;
  
  
  while ( ! stepComplete ) {
    switch( gameMode ) {
      case MODE_NONE: 
        newGame();
        gameMode = MODE_NEXTPLAYER;
        break;
        
      case MODE_NEXTPLAYER: 
        // Check for END
        if ( gameEnded() ) {
          stepComplete = endGame();
          gameMode = MODE_NONE;
        } else {
          stepComplete = newTurn();
          gameMode = MODE_PLAYERA;
        }
        break;


      case MODE_PLAYERA: 
      case MODE_PLAYERB: 
        // actual player has finished
        if ( hasSetAField ) {
          gameMode = MODE_OTHER;
        } else {
          stepComplete = true;
        }
        break;
        
      case MODE_OTHER: 
        stepComplete = newOther();
        if ( playerOther >= numPlayer ) {
          gameMode = MODE_NEXTPLAYER;
          stepComplete = false;
        }
        break;
        
    }
  }
}
 
 
 
/*************************************************************************************************/
/****************  handle Form changes                                                     *******/
/*************************************************************************************************/


public void handleFormToggle( PicToggle pt ) {

/*  */
  print("HFT : ");
  print( pt.getFColor() );
  print( "," );
  print( pt.geField() );
  println();
/* */

  int fcol = pt.getFColor();
  int fld = pt.geField();
  
  int dval = calcValue( fcol, fld );

  switch( gameMode ) {
      
    case MODE_PLAYERA: 
      if ( pt.getState() ) {
        // check fail 
        if ( dval == -1 ) {
           // Kreuz gesetzt also sperre andere Eingaben und nur noch Rücknahm erlaubt
           hasSetAField = true;
           resetForm( fcol, fld );
        
        // check dval matches 
        } else if ( dval != d.getOtherValue() ) {
          // weiss passt nicht also teste farbe
          if ( ! d.isColorValue(fcol, dval) ) {
            // passt auch nicht also zurück
            resetField( pt );

          // Kreuz passt zum Wuerfel check for last field
          } else if ( fld == 10 ) {
            if ( playerSDs[playerActual].allowEnd( fcol ) ) {
              // wenn letztes Feld dann auch Ende setzen 
              println("mark 11 " + fcol);
              setField( ptMark[fcol][11], true );
              hasSetAField = true;
              resetForm( fcol, fld );
            } else {
             // Ende nicht erlaubt
             resetField( pt );
            }            
          } else {
            // Alles ok beim Farbwürfel also nur reset
            hasSetAField = true;
            resetForm( fcol, fld );
          }

        // Kreuz passt zum Wuerfel (weiss) check for last field
        } else if ( fld == 10 ) {
          if ( playerSDs[playerActual].allowEnd( fcol ) ) {
            // wenn letztes Feld dann auch Ende setzen 
              println("mark 11b " + fcol);
            setField( ptMark[fcol][11], true );

            // speichere Feld
            playerStore1Fld = fld;
            playerStore1FCol = fcol;
            hasSetAField = true;
            gameMode = MODE_PLAYERB;

          } else {
            // Ende nicht erlaubt
            resetField( pt );
          }

        // Weiss passt also erster Schritt gemacht
        } else {
          // speichere Feld 
          playerStore1Fld = fld;
          playerStore1FCol = fcol;
          hasSetAField = true;
          gameMode = MODE_PLAYERB;
        }
      } else {
        // field is resetted
        hasSetAField = false;
        initForm( playerSDs[playerActual] );
      }
      break;          
          
    case MODE_PLAYERB: 
      if ( pt.getState() ) {
        // check fail 
        if ( dval == -1 ) {
           // Kreuz gesetzt not allowed
           resetField( pt );

        // in B farbwürfel muss passen
        } else if ( ! d.isColorValue(fcol, dval) ) {
          // passt auch nicht also zurück
          resetField( pt );

        // setting entry for color dice to lower number is not allowed
        } else if ( ( fcol == playerStore1FCol ) && ( fld <= playerStore1Fld ) ) {
          // also zurück
          resetField( pt );

        } else if ( ( fld == 10 ) && 
                    ( ! playerSDs[playerActual].allowEnd( fcol ) ) &&
                    ( ( playerSDs[playerActual].countMarks( fcol ) == 4 ) && ( fcol != playerStore1FCol ) ) 
                  ) {
          // fld 10 war nicht erlaubt
          resetField( pt );

        } else {
          if ( fld == 10 ) {
            // wenn letztes Feld dann auch Ende setzen 
            println("mark 12 " + fcol);
            setField( ptMark[fcol][11], true );
          }
          // now all ok only allow reset
          resetForm( fcol, fld );
        }
       
      // reset   
      } else if ( ( fcol == playerStore1FCol ) && ( fld == playerStore1Fld ) ) {
        // A field is resetted
        initForm( playerSDs[playerActual] );
        hasSetAField = false;
        gameMode = MODE_PLAYERA;

      } else {
        // B field is resetted
        initForm( playerSDs[playerActual] );
        setField( ptMark[playerStore1FCol][playerStore1Fld], true );

      }
      break;


    case MODE_OTHER: 
      if ( pt.getState() ) {
        // check dval matches 
        if ( dval != d.getOtherValue() ) {
          resetField( pt );

        // Kreuz passt zum Wuerfel check for last field
        } else if ( fld == 10 ) {
          if ( playerSDs[playerOther].allowEnd( fcol ) ) {
            // wenn letztes Feld dann auch Ende setzen 
            setField( ptMark[fcol][11], true );
          } else {
           // Ende nicht erlaubt
          resetField( pt );
          }            
        } else {
           // Kreuz gesetzt also sperre andere Eingaben und nur noch Rücknahm erlaubt
           resetForm( fcol, fld );
        }        
      } else {
        // field is resetted
        initForm( playerSDs[playerOther] );
      }
      break;
  }
  



}



