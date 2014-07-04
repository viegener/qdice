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

PImage don, doff, aon, aoff;
PImage fdon, fdoff, faon, faoff;

PicToggle ptMark[][];
PicToggle ptFail[];

PicToggle txtW1;
PicToggle txtW2, txtR, txtG, txtB, txtY;

Button btnPlay, btnForm;
Button btnSForms[];


boolean initForm;

/*************************************************************************************************/

static final int formOffsetX = 5;
static final int formOffsetY = 50;

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

static final int qmSizeX = formSizeX/4;
static final int qmSizeY = formSizeY/4;

static final int padSize = 10;

static final String pt_base = "pt"; 

/*************************************************************************************************/
/****************  Create the GUI during setup()                                           *******/
/*************************************************************************************************/

public void initializeGUI() {
  int posX, posY;
  String ptName;

  size(1000, 550);
  frameRate(30); 
  frame.setTitle(MYQDICE_PARSER_COPYRIGHT);

  PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
  PFont pfontEditor = createFont("Courier",12,true); // use true/false for smooth/no-smooth
  PFont pfontBig = createFont("Arial",14);

  doff = loadImage("default-off.png");
  aoff = loadImage("active-off.png"); 
  don = loadImage("default-on.png");
  aon = loadImage("active-on.png");

  fdoff = loadImage("fail-off.png");
  faoff = loadImage("failactive-off.png"); 
  fdon = loadImage("fail-on.png");
  faon = loadImage("failactive-on.png");

  rainbow = loadImage("rainbow.png");

  cp5 = new ControlP5(this, pfont); 

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


  qpage = loadImage( "qdice-small.png" );
  qpage.resize( formSizeX, formSizeY );

  qepage = loadImage( "qdice-end.png" );
  qepage.resize( formSizeX, formSizeY );

  qspage = loadImage( "qdice-splash.png" );
  qspage.resize( formSizeX, formSizeY );

  qmpage = loadImage( "qdice-mini.png" );
  qmpage.resize( qmSizeX, qmSizeY );

  btnForm = cp5.addButton("btnForm")
     .setPosition(formOffsetX, formOffsetY )
     .setSize(qpage.width, qpage.height)
     .setImage( qpage )
     .moveTo( tabDefault )
     ;

  btnSForms = new Button[MAX_PLAYER];
  posY = formOffsetY-(MAX_PLAYER * padSize / 2);
  for ( int i=0; i< MAX_PLAYER; i++ ) {
    btnSForms[i] = cp5.addButton("btnSForms" + i)
       .setPosition(formOffsetX+formSizeX + padSize, posY  )
       .setSize(qmpage.width + padSize, qmpage.height + padSize)
       .setImage( qmpage )
       .hide()
       .moveTo( tabDefault )
       ;
    posY += qmpage.height + padSize; 
    }

  initForm = true;

  PicToggle pt;

  ptMark = new PicToggle[4][12];
  ptFail= new PicToggle[4];

  /* add marks */
  posY = startY;

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

  txtW1 = new PicToggle( cp5, "txtW1");
  txtW1.setPosition(formOffsetX, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFFFFFFFF )
     .setColorBackground( 0xFFDDDDDD )
     .setColorForeground( 0xFFDDDDDD )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;


  txtW2 = new PicToggle( cp5, "txtW2");
  txtW2.setPosition(formOffsetX+30, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFFFFFFFF )
     .setColorBackground( 0xFFDDDDDD )
     .setColorForeground( 0xFFDDDDDD )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;

  txtR = new PicToggle( cp5, "txtR");
  txtR.setPosition(formOffsetX+60, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFFFF0000 )
     .setColorBackground( 0xFFDD0000 )
     .setColorForeground( 0xFFDD0000 )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;

  txtY = new PicToggle( cp5, "txtY");
  txtY.setPosition(formOffsetX+90, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFFFFFF00 )
     .setColorBackground( 0xFFDDDD00 )
     .setColorForeground( 0xFFDDDD00 )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;

  txtG = new PicToggle( cp5, "txtG");
  txtG.setPosition(formOffsetX+120, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFF00FF00 )
     .setColorBackground( 0xFF00DD00 )
     .setColorForeground( 0xFF00DD00 )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;

  txtB = new PicToggle( cp5, "txtB");
  txtB.setPosition(formOffsetX+150, 10 )
     .setSize(20, 20)
//     .setColor( 0xFFFFFFFF )
     .setColorActive( 0xFF0000FF )
     .setColorBackground( 0xFF0000DD )
     .setColorForeground( 0xFF0000DD )
     .setCaptionLabel( "--" )
     .moveTo( tabDefault )
     ;

// TODO: change colors or button
  btnPlay = cp5.addButton("btnPlayStep")
     .setPosition(500, 25 )
     .setSize(100, 20)
     .setCaptionLabel( " Play " )
//     .setColorBackground( 0xFFFFFFFF )
     .moveTo( tabDefault )
     ;

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

  btnForm.setImage( qspage );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnSForms[i].hide();
  }
  
  resetForm();
}

public void initScreenGame() {
  tabDefault.bringToFront();

  btnForm.setImage( qpage );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnSForms[i].show();
  }
  
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

  btnForm.setImage( pg );  

  for ( int i=0; i< numPlayer; i++ ) {
    btnSForms[i].show();
  }

  resetForm();

}



/*************************************************************************************************/
/****************  Handle Buttons                                                          *******/
/*************************************************************************************************/


/* nothing */

/*************************************************************************************************/
/****************  PGraphics for small qpage                                               *******/
/*************************************************************************************************/

// 0 - inactive / 1 - other / 2 - player

public void showMiniForm( int plid, SData sd, int activeOther ) {
  btnSForms[plid].setImage( makeMPage(sd, activeOther) );
}


public PGraphics makeMPage( SData sd, int activeOther  ) {
  PGraphics pg = createGraphics( qmSizeX+padSize, qmSizeY+padSize);
  
  int stx = ((startX-formOffsetX) / 4)+1 + (padSize/2);
  int sty = ((startY-formOffsetY) / 4)+1 + (padSize/2);
  
  int stfx = ((startXf-formOffsetX) / 4)+1 + (padSize/2);
  int stfy = ((startYf-formOffsetY) / 4)+1 + (padSize/2);
  
  int ox = ((offsetX) / 4);
  int oy = ((offsetY) / 4)+1;
  
  int ofx = ((offsetXf) / 4);

  int h = 10;
  int w = 10;

  int posX, posY;
  
  pg.beginDraw();
  
  if ( activeOther == AO_PLAYER ) {
    pg.image(rainbow, 0, 0, qmSizeX+padSize, qmSizeY+padSize );
  } else if ( activeOther == AO_OTHER ) {
    pg.background( 0xFFDDDDDD );
  } else {
    pg.background( 0xff022020);
  }
  
  pg.image(qmpage, padSize/2,padSize/2, qmSizeX, qmSizeY);

  posY = sty;

  for ( int i = 0; i < 4; i++ ) {
    posX = stx;
    for ( int j=0; j<11; j++ ) {
      if ( sd.getMark( i, j ) ) {
        pg.line( posX, posY, posX+w, posY+h );
        pg.line( posX+w, posY, posX, posY+h );
      }
      
      posX += ox;
    }

    if ( sd.getMark( i, 11 ) ) {
      posX += (offsetXEnd/4);
      pg.line( posX, posY, posX+w, posY+h );
      pg.line( posX+w, posY, posX, posY+h );
    }
    
    posY += oy;
  }

  /* add fails */
  posX = stfx;
  posY = stfy;
  
  h = 5;
  w = 6;

  posX = stfx;
  for ( int i=0; i<sd.getFail(); i++ ) {

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
      ptMark[i][j].setSwitchable( true );
      ptMark[i][j].setState( sd.getMark( i, j ) );
      if ( sd.getMark( i, j ) ) {
        setSw = false;
      }
      ptMark[i][j].setSwitchable( setSw );
    }
    ptMark[i][11].setSwitchable( false );
  }

  for ( int i=0; i<4; i++ ) {
    ptFail[i].setSwitchable( true );
    if ( sd.getFail() > i ) {
      ptFail[i].setState( true );
      ptFail[i].setSwitchable( false );
    } if ( sd.getFail() == i ) {
      ptFail[i].setState( false );
      ptFail[i].setSwitchable( true );
    } else {
      ptFail[i].setState( false );
      ptFail[i].setSwitchable( false );
    }
    if ( gameMode == MODE_OTHER ) {
      ptFail[i].setSwitchable( false );
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
      ptMark[i][j].setSwitchable( true );
      ptMark[i][j].setState( false );
      ptMark[i][j].setSwitchable( false );
    }
  }

  for ( int i=0; i<4; i++ ) {
    ptFail[i].setSwitchable( true );
    ptFail[i].setState( false );
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
  boolean ss = pt.getSwitchable();
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
    if ( ptMark[i][11].getState() ) {
      sDataEnd[i] = true;
    }
    
  }

  for ( int i=0; i<4; i++ ) {
    if ( ptFail[i].isSwitchable() ) {
      if ( ptFail[i].getState() ) {
        sd.incFail();
      }
    }
  }

  if ( sd.getFail() == 4 ) {
    sDataEnd[4] = true;
  }

}


/*************************************************************************************************/
/****************  draw only for specific images                                           *******/
/*************************************************************************************************/


void draw() {
  // dark background
  background(0xff022020);
  /*
  if ( gpg != null ) {
    image( gpg, formOffsetX+650, formOffsetY );
  }
  */
} // end void draw  



/*************************************************************************************************/
/****************  showDice                                                                *******/
/*************************************************************************************************/

public void showDice( Dice d ) {

   txtW1.setCaptionLabel( "   "+str(d.w1) );
   txtW2.setCaptionLabel( "   "+str(d.w2) );
   txtR.setCaptionLabel(  "   "+str(d.r) );
   txtY.setCaptionLabel(  "   "+str(d.y) );
   txtG.setCaptionLabel(  "   "+str(d.g) );
   txtB.setCaptionLabel(  "   "+str(d.b) );
 
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
      handleFormToggle( (PicToggle) theEvent.getController() );
    }
  }

}
 
 
