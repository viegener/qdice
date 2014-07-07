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
/****************  Options                                                                                *******/
/****************  (store all options for handling in the AI                                              *******/
/*****************                                                                                ***************/
/****************************************************************************************************************/

public class Option extends Object {

  int color1, field1;
  int color2, field2;
  
  public Option( ) {
    setOption( idxFail, 0, -1, -1 );
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
  }


  public boolean isFail() {
    return (color1 == idxFail);
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

public class AIMOve extends Object {
    // ATTENTION: values must be converted to fields first depending on color row
    
    Option moves[];  
    int ctMoves;
    int dval;
  
    public AIMOve( SData sd, Dice d, boolean isActual ) {
      // calculate all possible options based on current sd and dices 
      moves = new Option[45];
      ctMoves = 0;
     
      // First option is to set fail
      moves[0] = new Option();
      ctMoves++;
      
      // check the white dices
//      dval = 
      
    }
  
  
}
