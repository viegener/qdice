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
 
 
/*************************************************************************************************/
/*****************                                                                 ***************/
/****************  P5GUI only init                                                         *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


import javax.swing.*;

import controlP5.*;




/*************************************************************************************************/
/****************  All Controls are currently Global                                       *******/
/*************************************************************************************************/

ControlP5 cp5;

Tab tabDefault; 
Tab tabEnd; 

PImage qpage, qmpage, qepage, qspage;
PImage rainbow;

PImage don, doff, aon, aoff, coff;
PImage fdon, fdoff, faon, faoff;

PicToggle ptMark[][];
PicToggle ptFail[];

Button btnPlay, btnForm;
Button btnMForms[];


Button btnDices[];
PImage picDices[];

static final int diceColor[] = { 
      0xFFDDDDDD,
      0xFFDDDDDD,
      0xFFDD0000,
      0xFFDDDD00,
      0xFF00DD00,
      0xFF0000DD
};

static final int diceOtherColor[] = { 
      0xFFDDDDDD,
      0xFFDDDDDD,
      0xFF660000,
      0xFF666600,
      0xFF006600,
      0xFF000088
};


static final int COL_BACKGROUND = 0xfff2f2f2;


boolean initForm;

/*************************************************************************************************/

static float guiScale;
static int sizeX;
static int sizeY;

static final int formOffsetX = 0; // 5;
static final int formOffsetY = 0;  // 50;

static final int startX = formOffsetX + 18;
static final int startY = formOffsetY + 10;

static final int startXf = formOffsetX + 489;
static final int startYf = formOffsetY + 300;

static final int offsetXEnd = 3;
static final int offsetX = +42+5;
static final int offsetY = +67;


static final int startXR = 108;
static final int offsetXR = 74;
static final int offsetXREnd = 30;

static final int offsetXf = 21+5;

static final int formSizeX = 600;
static final int formSizeY = 400;

static final int formSizeMY = 300;

static final int qmSizeX = formSizeX/4;
static final int qmSizeY = formSizeMY/4;

static final int diceSize = 30;

static final int padSize = 10;
static final int qmlabelSize = 20;

static final String pt_base = "pt"; 

/*************************************************************************************************/
/****************  Create the GUI during setup()                                           *******/
/*************************************************************************************************/



public int scaleUp(int val) {
  float temp = val;
  
  temp = temp * guiScale;
  
  return round( temp );
}


public int scaleDown(int val) {
  float temp = val;
  
  temp = temp / guiScale;
  
  return round( temp );
}


public void initializeGUI() {
  int posX, posY;
  String ptName;
  
  sizeX = formSizeX+(2*padSize)+qmSizeX;
  sizeY = formSizeY+(2*padSize);

  float gscx = sizeX;
  gscx = displayWidth / gscx;
  
  float gscy = sizeY;
  gscy = displayHeight / gscy;

  guiScale = gscx;
  if ( gscy < gscx ) {
    guiScale = gscy;
  }

/*
  println();
  println(guiScale);
  println();
*/

//  size(sizeX, sizeY);
  size(displayWidth, displayHeight);
  frameRate(30); 
//??? ANDROID   frame.setTitle(MYQDICE_PARSER_TITLE_REV);


  PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
  PFont pfontEditor = createFont("Courier",12,true); // use true/false for smooth/no-smooth
  PFont pfontBig = createFont("Arial",14);

  doff = loadImage("default-off.png");
  doff.loadPixels();
  aoff = loadImage("active-off.png"); 
  aoff.loadPixels();
  don = loadImage("default-on.png");
  don.loadPixels();
  aon = loadImage("active-on.png");
  aon.loadPixels();

  fdoff = loadImage("fail-off.png");
  fdoff.loadPixels();
  faoff = loadImage("failactive-off.png"); 
  faoff.loadPixels();
  fdon = loadImage("fail-on.png");
  fdon.loadPixels();
  faon = loadImage("failactive-on.png");
  faon.loadPixels();

  coff = loadImage("closed-off.png");
  coff.loadPixels();

  rainbow = loadImage("rainbow.png");
  rainbow.loadPixels();
  
  cp5 = new ControlP5(this, pfont); 

  cp5.setScale( guiScale );

  /*********************/
  /* Tabs */
  
  tabDefault = cp5.getTab("default")
     .setLabel("  Play  ")
     .setId(1)
     .activateEvent( true )
     ; 

/*  
  tabEnd = cp5.getTab("end")
     .setLabel("  End  ")
     .setId(2)
     .activateEvent( true )
     ; 
*/

  qpage = loadImage( "qdice-form.png" );
  qpage.resize( formSizeX, formSizeY );
  qpage.loadPixels();

  qepage = loadImage( "qdice-end.png" );
  qepage.resize( formSizeX, formSizeY );
  qepage.loadPixels();

  qspage = loadImage( "qdice-splash.png" );
  qspage.resize( formSizeX, formSizeY );
  qspage.loadPixels();

  qmpage = loadImage( "qdice-mini-b.png" );
  qmpage.resize( qmSizeX, qmSizeY ); 
  qmpage.loadPixels();

  btnForm = cp5.addButton("btnForm")
     .setPosition(formOffsetX, formOffsetY )
     .setSize(qpage.width, qpage.height)
     .setImage( qpage )
     .moveTo( tabDefault )
     ;

  btnMForms = new Button[MAX_PLAYER];
//  posY = formOffsetY-(MAX_PLAYER * padSize / 2);
  posY = formOffsetY;
  for ( int i=0; i< MAX_PLAYER; i++ ) {
    btnMForms[i] = cp5.addButton("btnMForms" + i)
       .setPosition(formOffsetX+formSizeX + padSize, posY  )
       .setSize(qmpage.width + padSize, qmpage.height + qmlabelSize + padSize )
       .setImage( qmpage )
       .hide()
       .moveTo( tabDefault )
       ;
//    println("height : " + qmpage.height ); 
    posY += qmpage.height + qmlabelSize + padSize; 
    }

  PicToggle pt;

  ptMark = new PicToggle[4][12];
  ptFail= new PicToggle[4];

  /* add marks */
  posY = startY;
  initForm = true;

  for ( int i = 0; i < 4; i++ ) {
    posX = startX;
  
    ptName = pt_base + i + "_";
  
    for ( int j=0; j<11; j++ ) {
      ptMark[i][j] = addPicToggleMark( posX, posY, ptName + j );      
  
      ptMark[i][j] .setPos( i, j );

      posX += offsetX;
//      if ( j%3 == 0 )
//        posX++;
    }

    posX += offsetXEnd;
    ptMark[i][11] = addPicToggleMark( posX, posY, ptName + "X" );      
    ptMark[i][11].setPos( i, 11 );

    posY += offsetY;
    if ( i == 2 )
      posY++;
  }

  /* add fails */
  posX = startXf;
  posY = startYf;
  
  ptName = pt_base + "_f_";
  for ( int i=0; i<4; i++ ) {

    ptFail[i] = addPicToggleFail( posX, posY, ptName + i );      
    ptFail[i].setPos( 4, i );

    posX += offsetXf;
  }

  initForm = false;

  /***********************************************/

  btnPlay = cp5.addButton("btnPlay")
     .setPosition(formOffsetX + formSizeX - 320, startY + ( 5 * offsetY ) )
     .setSize(300, 30)
     .setCaptionLabel( " Play " )
//     .setColorBackground( 0xFFFFFFFF )
     .moveTo( tabDefault )
     ;


  /****************** DICES ***************/

  btnDices = new Button[NUM_DICES];
  picDices = new PImage[7];

  picDices[1] = loadImage( "dice-1.png" );
  picDices[2] = loadImage( "dice-2.png" );
  picDices[3] = loadImage( "dice-3.png" );
  picDices[4] = loadImage( "dice-4.png" );
  picDices[5] = loadImage( "dice-5.png" );
  picDices[6] = loadImage( "dice-6.png" );

  for ( int i=1; i< 7; i++ ) {
    picDices[i].resize( diceSize, diceSize );
    picDices[i].loadPixels();

  }

  posY = startY + ( 5 * offsetY );
  posX = startX;
  
  for ( int i=0; i< NUM_DICES; i++ ) {
    btnDices[i] = cp5.addButton("btnDices" + i)
       .setPosition(posX, posY  )
       .setSize(diceSize, diceSize)
       .setImage( picDices[i+1] )
       .hide()
       .moveTo( tabDefault )
       ;
    posX += diceSize + padSize; 
  }


}


public PicToggle addPicToggleMark( int posX, int posY, String name ) {

  PicToggle pt = new PicToggle( cp5, name); 
   
  pt.setPosition(posX, posY)
     .setSize(42,40)
     .setImages(doff, aoff, don, aon )
     .setColorBackground(color(0,100))
     .setColorForeground(color(80,100))
     .setColorActive(color(80,100))
     .moveTo( tabDefault )
     ;

  return pt;
}

public PicToggle addPicToggleFail( int posX, int posY, String name ) {

  PicToggle pt = new PicToggle( cp5, name); 
   
  pt.setPosition(posX, posY)
     .setSize(21,29)
     .setImages(fdoff, faoff, fdon, faon )
     .setColorBackground(color(0,100))
     .setColorForeground(color(80,100))
     .setColorActive(color(80,100))
     .moveTo( tabDefault )
     ;

  return pt;
}

/*************************************************************************************************/
/****************  Init different mode screens                                             *******/
/*************************************************************************************************/

public void initScreenSplash() {
  tabDefault.bringToFront();

//  btnForm.setPosition((width - formSizeX)/2 , formOffsetY );
  btnForm.setPosition(scaleDown((width - scaleUp(formSizeX))/2 ), scaleUp(formOffsetY) );
  btnForm.setImage( qspage );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnMForms[i].hide();
  }
  for ( int i=0; i< NUM_DICES; i++ ) {
    btnDices[i].hide();
  }
  
  btnPlay.hide();

  resetForm();
}

public void initScreenGame() {
  tabDefault.bringToFront();

  btnForm.setPosition(formOffsetX, formOffsetY );
  btnForm.setImage( qpage );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnMForms[i].show();
  }
  for ( int i=0; i< NUM_DICES; i++ ) {
    btnDices[i].show();
  }
  
  btnPlay.show();

}

public void initScreenEnd() {
  tabDefault.bringToFront();

  resetForm();

  PGraphics pg = createGraphics( formSizeX, formSizeY );
  
  pg.beginDraw();
  pg.image(qepage, 0,0, formSizeX, formSizeY);

  for ( int i=0; i<numPlayer; i++ ) {
    showResult(i, playerSDs[i], pg );
  }

  pg.endDraw();

  btnForm.setPosition(formOffsetX, formOffsetY );
  btnForm.setImage( pg );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnMForms[i].show();
  }
  for ( int i=0; i< NUM_DICES; i++ ) {
    btnDices[i].hide();
  }

  btnPlay.show();

  resetForm();

}



/*************************************************************************************************/
/****************  Handle Buttons                                                          *******/
/*************************************************************************************************/

public void btnPlay(int theValue) {
  playNextStep();
}
  
public void btnForm(int theValue) {
  if ( gameMode == MODE_NONE ) {
    playNextStep();
  }
}
  
  
/*************************************************************************************************/
/****************  PGraphics for small qpage                                               *******/
/*************************************************************************************************/

// 0 - inactive / 1 - other / 2 - player / 3- player (but not active)

public void showMiniForm( int plid, SData sd, int activeOther ) {
  btnMForms[plid].setImage( makeMPage( plid, sd, activeOther) );
}


public PGraphics makeMPage( int plid, SData sd, int activeOther  ) {
  PGraphics pg = createGraphics( qmSizeX+padSize, qmlabelSize + qmSizeY+padSize);
  
  int stx = ((startX-formOffsetX) / 4)+1 + (padSize/2) + 2;   // last is correction for smaller cross (4/2)
  int sty = ((startY-formOffsetY) / 4)+1 + (padSize/2) + 3 + qmlabelSize;
  
  int stfx = ((startXf-formOffsetX) / 4)+1 + (padSize/2) - 1;
  int stfy = ((startYf-formOffsetY) / 4)+1 + (padSize/2) + qmlabelSize - 8;
  
  int ox = ((offsetX) / 4);
  int oy = ((offsetY) / 4);
  
  int ofx = ((offsetXf) / 4);

  int h = 5;
  int w = 5;

  int posX, posY;
  
  pg.beginDraw();
  
  pg.background( COL_BACKGROUND );
  if ( activeOther == AO_PLAYER ) {
    pg.image(rainbow, 0, 0, qmSizeX+padSize, qmSizeY+qmlabelSize+padSize );
  } else if ( activeOther == AO_PLAYERDONE ) {
    pg.image(rainbow, padSize/2, 0,  qmSizeX, qmlabelSize + (padSize/2) );
  } else if ( activeOther == AO_OTHER ) {
// OTHER means no fill
    pg.fill( 0xff404040 );
    pg.rect( padSize/2, 0,  qmSizeX, qmlabelSize + (padSize/2) );
  } else {
  }
  
  pg.textSize( 14 );
//  pg.fill( 0xFFEEEEEE );
  pg.fill( 0xFF000000 );
  if ( activeOther == AO_PLAYER ) {
    pg.text( "* Spieler " + (plid+1) + " *", padSize, qmlabelSize );
  } else if ( activeOther == AO_PLAYERDONE ) {
    pg.text( "Spieler " + (plid+1), padSize, qmlabelSize );
  } else if ( activeOther == AO_OTHER ) {
    pg.fill( COL_BACKGROUND );
    pg.text( "* Spieler " + (plid+1) + " *", padSize, qmlabelSize );
  } else {
    pg.text( "Spieler " + (plid+1), padSize, qmlabelSize );
  }

  pg.image(qmpage, padSize/2, qmlabelSize + (padSize/2), qmSizeX, qmSizeY);

  posY = sty;

  for ( int i = 0; i < 4; i++ ) {
    posX = stx;
    for ( int j=0; j<11; j++ ) {
      if ( sd.getMark( i, j ) ) {
        pg.strokeWeight(4);
        pg.line( posX, posY, posX+w, posY+h );
        pg.line( posX+w, posY, posX, posY+h );
      }
      
      posX += ox;
      if ( (j%2) == 0 ) {
        posX += 1;
      }
      if ( (j%3) == 1 ) {
        posX ++;
      }
    }

    if ( sd.getMark( i, 11 ) ) {
      posX += (offsetXEnd/4);
      pg.line( posX, posY, posX+w, posY+h );
      pg.line( posX+w, posY, posX, posY+h );
    }
    
    posY += oy;
//    if ( (i%2) == 1 ) {
//      posY ++;
//    }
  }

  /* add fails */
  posX = stfx;
  posY = stfy;
  
  h = 5;
  w = 6;

  posX = stfx;
  for ( int i=0; i<sd.getFail(); i++ ) {
//  for ( int i=0; i<4; i++ ) {

    pg.line( posX, posY, posX+w, posY+h );
    pg.line( posX+w, posY, posX, posY+h );

    posX += ofx;
  }

  pg.endDraw();
  
  return pg;
}



 
/*************************************************************************************************/
/****************  Init Form from SData                                                    *******/
/*************************************************************************************************/

public void initForm( SData sd ) {
  initForm = true;

  for ( int i=3; i>=0; i-- ) {
    boolean setSw = ! sDataEnd[i];
    for ( int j=11; j>=0; j-- ) {
      ptMark[i][j].forceState( sd.getMark( i, j ) );
      if ( sd.getMark( i, j ) ) {
        setSw = false;
      }
      ptMark[i][j].setSwitchable( setSw );
    }
    
    if ( sDataEnd[i] ) {
      ptMark[i][11].setImage( coff, Controller.DEFAULT );
    } else {
      ptMark[i][11].setImage( doff, Controller.DEFAULT );
    }
    ptMark[i][11].setSwitchable( false );
  }

  for ( int i=0; i<4; i++ ) {
    if ( sd.getFail() > i ) {
      ptFail[i].forceState( true );
      ptFail[i].setSwitchable( false );
    } else if ( sd.getFail() == i ) {
      ptFail[i].forceState( false );
      ptFail[i].setSwitchable( true );
    } else {
        ptFail[i].forceState( false );
      ptFail[i].setSwitchable( false );
    }
    if ( gameMode == MODE_OTHER ) {
      ptFail[i].setSwitchable( false );
    } 
  }

  initForm = false;
}


/*************************************************************************************************/
/****************  UPdate Form from Option                                                 *******/
/*************************************************************************************************/

public void updateForm( Option move ) {
  initForm = true;

  if ( move.isNone() ) {
    return;
  } else if ( move.isFail() ) {
    for ( int i=0; i<4; i++ ) {
      if ( ! ptFail[i].getState() ) {
        ptFail[i].forceState( true );
        return;
      }
    }
  } else {
    ptMark[move.color1][move.field1].forceState( true );
    if ( move.isFinal1() ) {
      ptMark[move.color1][move.field1+1].forceState( true );
    }

    if ( move.isDouble() ) {
      ptMark[move.color2][move.field2].forceState( true );
      if ( move.isFinal2() ) {
        ptMark[move.color2][move.field2+1].forceState( true );
      }
    }

  }

  initForm = false;
}

/*************************************************************************************************/
/****************  reset Form                                                              *******/
/*************************************************************************************************/

public void resetForm( ) {
  initForm = true;
  
  for ( int i=3; i>=0; i-- ) {
    for ( int j=11; j>=0; j-- ) {
      ptMark[i][j].forceState( false );
      ptMark[i][j].setSwitchable( false );
    }
    ptMark[i][11].setImage( doff, Controller.DEFAULT );
  }

  for ( int i=0; i<4; i++ ) {
    ptFail[i].forceState( false );
    ptFail[i].setSwitchable( false );
  }

  initForm = false;
}


public void resetForm( int fCol, int field ) {
  initForm = true;
  for ( int i=3; i>=0; i-- ) {
    for ( int j=11; j>=0; j-- ) {
      if ( ( fCol == i ) && ( field == j ) ) { 
        ptMark[i][j].setSwitchable( true );
      } else {
        ptMark[i][j].setSwitchable( false );
      }
    }
  }
  for ( int i=0; i<4; i++ ) {
   if ( ( fCol == 4 ) && ( field == i ) ) { 
     ptFail[i].setSwitchable( true );
    } else {
     ptFail[i].setSwitchable( false );
    }      
  }
  initForm = false;
}
  
public void resetField( PicToggle pt  ) {
  setField( pt, false );
}
  
public void setField( PicToggle pt, boolean value  ) {
  initForm = true;
  boolean ss = pt.isSwitchable();
  pt.setSwitchable( true );
  pt.setState( value );
  pt.setSwitchable( ss );

  initForm = false;
}
  
/*************************************************************************************************/
/****************  get SData from Form                                                     *******/
/*************************************************************************************************/

public void updateSData( SData sd ) {
  for ( int i=3; i>=0; i-- ) {
    boolean setSw = true;
    for ( int j=11; j>=0; j-- ) {
//      if ( ptMark[i][j].isSwitchable() ) {
        if ( ptMark[i][j].getState() ) {
          sd.setMark(i,j);
        }
//      }
    }
  }

  for ( int i=0; i<4; i++ ) {
    if ( ptFail[i].isSwitchable() ) {
      if ( ptFail[i].getState() ) {
        sd.incFail();
      }
    }
  }

}


/*************************************************************************************************/
/****************  draw only for specific images                                           *******/
/*************************************************************************************************/


void draw() {
   scale( guiScale );
  // dark background
//  background(0xff022020);
  background(COL_BACKGROUND);
  /*
  if ( gpg != null ) {
    image( gpg, formOffsetX+650, formOffsetY );
  }
  */
} // end void draw  



/*************************************************************************************************/
/****************  showDice                                                                *******/
/*************************************************************************************************/


public void showDice( Dice d, boolean active ) {

  /* new with pictures */
  for( int i=0; i<NUM_DICES; i++ ) {
    PGraphics pg = createGraphics( diceSize, diceSize );;
  

    pg.beginDraw();
    if ( active ) {
      pg.background( diceColor[i] );
    } else {
      pg.background( diceOtherColor[i] );
    }
  
    pg.image(picDices[ d.getDiceValue(i) ], 0,0, diceSize, diceSize );
    pg.endDraw();
    
    btnDices[i].setImage( pg );
  }

}


/*************************************************************************************************/
/****************  showResult                                                                *******/
/*************************************************************************************************/

public void showResult( int nPlayer, SData sd, PGraphics pg ) {
  

  int posx = startXR;
  int posy = startY - formOffsetY + (nPlayer*offsetY) + (offsetY/2);
  
  pg.textSize(24);
  pg.textAlign( CENTER );
  pg.fill(0xFF111111);
  
  pg.text("" + sd.calcPoints(0), posx, posy );
  posx += offsetXR;
  
  pg.text("" + sd.calcPoints(1), posx, posy );
  posx += offsetXR;
  
  pg.text("" + sd.calcPoints(2), posx, posy );
  posx += offsetXR;
  
  pg.text("" + sd.calcPoints(3), posx, posy );
  posx += offsetXR;

  pg.text("" + sd.calcPoints(4), posx, posy );
  posx += offsetXR;

  posx += offsetXREnd;
  pg.text("" + sd.calcPoints(), posx, posy );


}


/*************************************************************************************************/
/****************  Central Event Handler                                                   *******/
/*************************************************************************************************/

/*************************************************************************************************/
void controlEvent(ControlEvent theEvent) {

  if (  ( theEvent.getController() instanceof PicToggle) ) {  
    if ( ! initForm ) {
/*
      print("Mouse " );
      print( mouseX ); 
      print( ":" ); 
      print( mouseY ); 
      println();
      PVector pv = ((PicToggle) theEvent.getController()).getAbsolutePosition();
      print("AbsolutePosition " );
      print( pv.x ); 
      print( ":" ); 
      print( pv.y ); 
      println();
      pv = ((PicToggle) theEvent.getController()).getPosition();
      print("Position " );
      print( pv.x ); 
      print( ":" ); 
      print( pv.y ); 
      println();
*/      
      handleFormToggle( (PicToggle) theEvent.getController() );
    }
  }

}
 
 
