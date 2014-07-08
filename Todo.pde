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
/****************  TODO (and Done LIST)  --> No real code in h                             *******/
/*****************                                                                 ***************/
/*************************************************************************************************/


static final String MQ_VERSION = "1.0";
static final String MQ_REVISION = "2013/07/05"; 

static final String MYQDICE_PARSER_TITLE_REV = "QDICE V" + MQ_VERSION + " - " + MQ_REVISION; 

static final String MYQDICE_PARSER_COPYRIGHT = "Copyright (C) 2014 by Johannes Viegener";

/***************** TODO **********************************************************


TODO
- add mark for closed lines
- select number of players / KIs
- add multi KI
- add auto mode KI against KI with log file


- add hints for possible moves
    - prio 1 ist abschliessen - wenn gute punktzahl
    - prio 2 versuche so nah wir moeglich - 0 dist (1 dist akzaptabel / 2-dist nur wenn nicht zu oft und noch gut Platz)
    - prio 3 versuche beide Wuerfel als aktiver spieler zu setzen (aber nur mit guten / max akzeptablen werten)
    Versuche gute Verteilung zu bekommen - d.h also moeglichst viele Zahlen nutzbar
    Bei wenig platz akzeptiere nur noch 0-dist
    
- add kI

- switchable und set ist rot nicht schwarz
- dynamic player count
- android test
- store game for resume
- quit game

** 8.7.
- implemented basic KI
- 2 player mode with KI


** 4.7. 
- new splash screen
- clean up Game module
- add mini forms
- miniForms for player
- remove action buttons
- add visual for showing which player is on
- calibrate small forms - crosses smaller and more central
- FIX: corrrected title for naming the program
- reduce size of window
- würfel icons
- move playbutton
- show other/active on dices
- new pictures without frame
- FIX: special case white mark is making 5th mark in color-allow end mark
- start game on splash
- add specific texts and counts form player
- splash screen in the middle
- add text for Player
- make actual player mark more visible
- define version 1
- add area to click on splashscreen due to large number of other buttons that filter clicks

** 3.7. Complete game
- complete general game flow
- special case no mark or all marks reversed!!!
- add playerb mode
- test for game over
- calculate points
- SPlashscreen added
- add result screen
- deactivate form if not active


** 2.7. IMprove game
- test for finished other
- enable last num column only with  min 5 crosses


** 1.7. create Form functionality
- add general game flow
- show wuerfel
- show small status
- Fails markieren
- stand repräsentieren
- stand in darstellung umsetzen

** 29.6.2014 INITIAL

/*********************************************************************************/
