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
 
 
void setup(){

  println();
  println(MYQDICE_PARSER_TITLE_REV);
  println(MYQDICE_PARSER_COPYRIGHT);
  
  println();
  println("Ths program comes with ABSOLUTELY NO WARRANTY;");
  println("This is free software, and you are welcome to redistribute it under certain conditions;");
  println();  
 
  initializeGUI();
  btnClear(1);
 
  println();
  println(MYQDICE_PARSER_TITLE_REV);
  println(MYQDICE_PARSER_COPYRIGHT);
  
  println();
  
  initScreenSplash();
}
 

