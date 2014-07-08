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
/****************  PicToggle                                                                              *******/
/****************  (extends Toggle to have correct image handling and deactivation from CP5)              *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

/*
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.util.Map; 
import java.util.HashMap; 

import processing.core.PApplet;
import processing.event.KeyEvent; 
*/

/*************************************************************************************************/
/****************  Extended Toggle                                                      *******/
/*************************************************************************************************/

public class PicBaseToggle extends Toggle {
  boolean nonSwitchable = false;

  public PicBaseToggle(ControlP5 theControlP5, String theName) {
    super( theControlP5, theName );
  }


  public PicBaseToggle setState(boolean theFlag) { 
    if ( nonSwitchable ) {
      println("ERR >>> Not switchable ");
    } else {
      super.setState( theFlag );
    }
   return this;
  }
  
  public PicBaseToggle forceState(boolean theFlag) { 
   super.setState( theFlag );
   return this;
  }
  
  public PicBaseToggle setSwitchable( boolean theSW ) {
   nonSwitchable = ! theSW;
   return this;
  }

  public boolean isSwitchable( ) {
   return ! nonSwitchable;
  }

  protected void updateFont(ControlFont theControlFont) {
    _myCaptionLabel.updateFont(theControlFont);
  } 
  
   public PicBaseToggle updateDisplayMode(int theState) {
    if ( theState == IMAGE ) {
      _myControllerView = new PicBaseToggleImageView();
    } else {
      super.updateDisplayMode( theState); 
    }
    return this;
  } 

  class PicBaseToggleImageView implements ControllerView<Toggle> {

    public void display(PApplet theApplet, Toggle theController) {
      if (getIsInside() && ( ! nonSwitchable) ) {
        if (isOn) {
          theApplet.image( (availableImages[HIGHLIGHT] == true) ? images[HIGHLIGHT] : images[DEFAULT], 0, 0);
        }
        else {
          theApplet.image( (availableImages[OVER] == true) ? images[OVER] : images[DEFAULT], 0, 0);
        }
      }
      else {
        if (isOn) {
          theApplet.image( (availableImages[ACTIVE] == true) ? images[ACTIVE] : images[DEFAULT], 0, 0);
        }
        else {
          theApplet.image( images[DEFAULT], 0, 0);
        }
      }
      theApplet.rect(0, 0, width, height);
    }
  } 


}


/****************************************************/

public class PicToggle extends PicBaseToggle {

  int tcolor, tfield;
  
  public void setPos( int ac, int af ) {
    tcolor = ac;
    tfield = af;
  }
  
  public int getFColor() {
    return tcolor;
  }
  
  public int geField() {
    return tfield;
  }
  
  
  
  
  public PicToggle(ControlP5 theControlP5, String theName) {
    super( theControlP5, theName );
  }


  
}

