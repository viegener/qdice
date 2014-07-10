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

static final int idxRed = 0;
static final int idxYel = 1;
static final int idxGre = 2;
static final int idxBlu = 3;

static final int idxFail = 4;
static final int idxRows = 4;
static final int idxNone = -1;


boolean sDataEnd[] = new boolean[ idxFail+1 ];

static final String upperLine = "23456789ABC";
static final String lowerLine = "CBA98765432";


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
    


/*************************************************************************************************/
/****************  convert field to dice values                                            *******/
/*************************************************************************************************/

public int calcValue( int fcol, int fld ) { 
  int dval;
  if ( fcol < 2 ) {
    dval = fld + 2;
  } else if ( fcol < 4 ) {
    dval = 12-fld;
  } else {
    dval = -1;
  }
  return dval;
}


public int calcField( int fcol, int value ) { 
  int fld;

  if ( fcol < 2 ) {
    fld = value - 2; 
  } else if ( fcol < 4 ) {
    fld = 12-value; 
  } else {
    fld = -1;
  }
  return fld;
}




/****************************************************************************************************************/
/*****************                                                                                ***************/
/****************  SData                                                                                  *******/
/****************  (store data for one sheet of qdice sheet)                                               *******/
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
    return ( countMarks( fcol ) >= 5 );
  } 
  

  public void updateDataEnd() {
    for ( int i=0; i<4; i++ ) {
      if (  mark[i][11] ) {
        sDataEnd[i] = true;
      }
    }
    if ( getFail() == 4 ) {
      sDataEnd[4] = true;
    }
  }


  public boolean allowSet( int fcol, int fld, int fcolSet, int fldSet ) {
    int cx = 0; 
    if ( sDataEnd[fcol] ) {
        return false;
    }  


    for ( int j=fld; j<11; j++ ) {
      if (  mark[fcol][j] ) {
        return false;
      }
    }
    
    if ( ( fcolSet == fcol ) && ( fldSet >= fld ) ) {
        return false;
    }  

    if ( fld == 10 ) {
      return allowEnd( fcol );
    }

    return true;
  } 
  
  public boolean allowSet( int fcol, int fld ) {
    return allowSet( fcol, fld, -1, -1 );
  } 
  

  public int countMarks( int fcol ) {
    int cx = 0; 

    for ( int j=0; j<11; j++ ) {
      if (  mark[fcol][j] ) {
        cx++;
      }
    }
    
    return cx; 
  } 
  
  public int lastMark( int fcol ) {
    for ( int j=10; j>=0; j-- ) {
      if (  mark[fcol][j] ) {
        return j;
      }
    }
    
    return -1; 
  } 
  
  
  public int calcPoints( int fcol ) {

    if ( fcol == 4 ) {
      return (fail * -5);
    } 

    int cx = 0; 
    int sx = 0; 
    for ( int j=0; j<11; j++ ) {
      if (  mark[fcol][j] ) {
        cx++;
        sx += cx;  
      }
    }

    return sx; 
  }
 
 
  public int calcPoints() {
    int cx = 0; 

    for ( int i=0; i<5; i++ ) {
      cx+= calcPoints(i);
    }
    
    return cx;


  }
  
  
  
  public String partString( int fcol ) {
    String ln = "";
    
    for ( int j=0; j<11; j++ ) {
      if (  mark[fcol][j] ) {
        ln = ln.concat( "x" );
      } else {
        if ( fcol < 2 ) {
          ln = ln.concat( String.valueOf( upperLine.toCharArray(), j, 1 ) );
        } else {
          ln = ln.concat( String.valueOf( lowerLine.toCharArray(), j, 1 ) );
        }
      }
    }
    
    if (  mark[fcol][10] ) {
      ln = ln.concat( "*" );
    } else {
      ln = ln.concat( "O" );
    }
    return ln;
    
  }



  public String toString() {
    return " R:" + partString(0) + ": " + str_f(calcPoints(0),4) + "  " +   
         " Y:" + partString(1) + ": " + str_f(calcPoints(1),4) + "  " + 
         " G:" + partString(2) + ": " + str_f(calcPoints(2),4) + "  " + 
         " B:" + partString(3) + ": " + str_f(calcPoints(3),4) + "  " + 
         " == " + str_f( calcPoints(), 4 );
    
  }
 
  
}
