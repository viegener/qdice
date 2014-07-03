/************************************************************************************************
 *
 *  qwix
 *
 *  Copyright 2014 by Johannes Viegener
 *
 *  This file is part of qwix.
 *
 *  qwix is free software: you can redistribute it and/or modify
 *  it under the terms of the Lesser GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  qwix is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Lesser GNU General Public License
 *  along with qwix.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author     Johannes Viegener
 *
 *************************************************************************************************/  

static final int idxRed = 0;
static final int idxYel = 1;
static final int idxGre = 2;
static final int idxBlu = 3;

static final int idxStr = 4;


boolean sDataEnd[] = new boolean[ idxStr+1 ];


/*************************************************************************************************/
/****************  calculate game end                                                     *******/
/*************************************************************************************************/

public boolean gameEnded() {
  int count = 0;

  if ( sDataEnd[4] ) {
    count = 2;
  } else {
    for ( int i=0; i<4; i++ ) {
      if ( sDataEnd[i] ) 
        count++;
    }
  }
  
  return ( count > 1 );
}
    


/****************************************************************************************************************/
/*****************                                                                                ***************/
/****************  SData                                                                                  *******/
/****************  (store data for one sheet of qwix sheet)                                               *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

public class SData extends Object {
  boolean mark[][];
  int fail;
  
  String name;
  
  public SData( String aName ) {
    name = aName;
    mark = new boolean[4][12];

    for ( int i=0; i<4; i++ ) {
      for ( int j=0; j<12; j++ ) {
        mark[i][j] = false;
      }
    }
    fail = 0;
  }

 public boolean getMark(int col, int pos) {
   return mark[col][pos];
 }




 public boolean setMark( int col, int pos ) {
  if ( ( col < 0 ) || ( col > 3 ) ) {
    println(">>>ERR> setMark : col is out of range:" + col);
  } 

  if ( ( pos < 0 ) || ( pos > 11 ) ) {
    println(">>>ERR> setMark : pos is out of range:" + pos);
  } 

  mark[col][pos] = true;
  return true;
 } 
  
 public boolean incFail( ) {
  if ( fail > 3 ) {
    println(">>>ERR> addFail : fail is already over limit" + fail);
  } 
  fail++;
  return true;
 } 
  

 public int getFail() {
   return fail;
 }
 
  public boolean allowEnd( int fcol ) {
    int cx = 0; 

    for ( int j=0; j<9; j++ ) {
      if (  mark[fcol][j] ) {
        cx++;
      }
    }
    
    return ( cx >= 5 ); 
  } 
  
}