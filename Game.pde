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
/*************************************************************************************************/

static final int MODE_NONE = 0;

static final int MODE_PLAYERA = 1;
static final int MODE_PLAYERB = 2;
static final int MODE_OTHER  = 3;
static final int MODE_OVER   = 4;


/*************************************************************************************************/

SData playerSDs[];
int playerActual;
int playerOther;

Dice d = new Dice();

int gameMode = MODE_NONE;

int playerStore1Fld, playerStore1FCol;
boolean hasSetAField;

/*************************************************************************************************/

public void newGame() {
  playerSDs = new SData[numPlayer];

  for ( int i=0; i<numPlayer; i++ ) {
     playerSDs[i] = new SData("Player "+(i+1));
  }
  
  for ( int i=0; i<5; i++ ) {
    sDataEnd[i] = false;
  }
  
  initScreenGame();

  playerActual = 1;
  
  newTurn();

}

/*************************************************************************************************/

public void newTurn() {
  d.roll();
  showDice( d );
  
  gameMode = MODE_PLAYERA;

  initForm( playerSDs[playerActual-1] );
  btnPlay.setCaptionLabel( "  Player " );
  
  hasSetAField = false;

  playerOther = 1;
  if ( playerOther == playerActual ) {
    playerOther++;
  }
}

/*************************************************************************************************/

public void newOther() {

  gameMode = MODE_OTHER;
  initForm( playerSDs[playerOther-1] );
  btnPlay.setCaptionLabel( "  Other " + playerOther );

}

/*************************************************************************************************/

public void endGame() {
  initScreenEnd();
  gameMode = MODE_OVER;
  
  

}


/*************************************************************************************************/

/*************************************************************************************************/
public void btnPlayStep(int theValue) {

  switch( gameMode ) {
    case MODE_NONE: 
      newGame();
//      endGame();
      break;
      
    case MODE_PLAYERA: 
    case MODE_PLAYERB: 
      // TODO: check player has finished
      if ( hasSetAField ) {
        updateSData( playerSDs[playerActual-1] );
        newOther();
      }
      break;
      
    case MODE_OTHER: 
      updateSData( playerSDs[playerOther-1] );

      playerOther++;
      if ( playerOther == playerActual ) {
        playerOther++;
      }

      if ( playerOther <= numPlayer ) {
        newOther();
      } else {
        playerActual++;
        if ( playerActual > numPlayer ) {
          playerActual = 1;
        }   
   
        // Check for ENDE
       if ( gameEnded() ) {
         endGame();
       } else {
         newTurn();
       }
      }
      break;
      
    case MODE_OVER: 
      newGame();
      break;
      
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
  
  int dval;
  if ( fcol < 2 ) {
    dval = fld + 2;
  } else if ( fcol < 4 ) {
    dval = 12-fld;
  } else {
    dval = -1;
  }


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
            if ( playerSDs[playerActual-1].allowEnd( fcol ) ) {
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
          if ( playerSDs[playerActual-1].allowEnd( fcol ) ) {
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
        initForm( playerSDs[playerActual-1] );
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

        } else if ( ( fld == 10 ) && ( ! playerSDs[playerActual-1].allowEnd( fcol ) ) ){
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
        initForm( playerSDs[playerActual-1] );
        hasSetAField = false;
        gameMode = MODE_PLAYERA;

      } else {
        // B field is resetted
        initForm( playerSDs[playerActual-1] );
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
          if ( playerSDs[playerOther-1].allowEnd( fcol ) ) {
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
        initForm( playerSDs[playerOther-1] );
      }
      break;
  }
  



}



