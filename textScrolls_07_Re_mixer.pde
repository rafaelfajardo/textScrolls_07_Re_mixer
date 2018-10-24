/*
 *
 *  textScrolls 03 (renamed Re:mixer on 2016 09 03)
 *  a sketch to help me generate
 *  remixes of synthetic tag cloud poem things
 *  
 *  it remixes an algorithm originally shared by Dan Shiffman
 *  and makes use of the letterforms
 *  WorkSans (SIL Open Font license 1.1)
 *  SourceCodePro (SIL Open Font license 1.1)
 *  FreeSans (GNU license)
 *
 *  p keystroke will write a PDF file of the next frame
 *  f keystroke will save a PNG file of the current frame
 *
 */
 
import processing.pdf.*; // enables the ability to generate PDFs
Boolean writePDF = false; // a variable to toggle the writing/saving of a PDF file from a frame of this sketch
String[] lines;  //array to hold lines input from data/fileName.txt file
String[] stanza = new String [10]; //lines will be placed into a stanza of 10 and displayed
PFont[] f = new PFont [10]; // global font variable
float x; // horizontal location (I may need one for each displayed line)
float w; // a placeholder for the widest line in the stanza
float[] xs= new float [10]; // x value for a set of rectangles
float[] ys= new float [10]; // y value for a set of rectangles
float[] ws= new float [10]; // width value for a set of rectangles
float[] hs= new float [10]; // height value for a set of rectangles
float[] r = new float [10]; // a place holder for 10 values for red
float[] g = new float [10]; // a place holder for 10 values for green
float[] b = new float [10]; // a place holder for 10 values for blue

void setup(){
   size (800, 400); // a purposefully "low" resolution 2880 x 1800 is a Macbook Pro 15" w/Retina Display full resolution
   pixelDensity(displayDensity()); // uses all the available pixels, will effectively double resolution with Retina display
   background(255); // creates a white background
   lines = loadStrings("tagpoems.txt"); //load the array of lines with the contents of the designated file
   for (int i=0; i<10; i++){
     stanza[i] = ""; // loop to initialize stanza to non-null values, avoid null-pointer errors
     f[i] = createFont("WorkSans-Regular.ttf", height/12, true);
     xs[i] = random(width/8, width*3/8); // assign left side of rectangles
     ys[i] = random(0, height/12); // assign top of rectangles
     ws[i] = random(width/4, width*6/8); // assign width for rectangles
     hs[i] = random(height/24, height/12); // assign height for rectangles
   }
   textAlign(LEFT); // choose flush left, ragged right alignment for displayed text
   x = width; // variable for the horizontal position of stanza, initialized off screen
   w = 0; // variable for the width of a line, start with the smallest possible width
}
 
void draw(){  // a loop to create frames of a composition to be displayed
     if (writePDF) {  // this chunk begins the writing of the PDF file and is placed at the beginning of the draw loop
       beginRecord(PDF, "output/pdf/Re:mixer stanza - "+year()+"-"+nf(month(),2)+"-"+nf(day(),2)+"-"+nf(hour(),2)+"-"+nf(minute(),2)+"-"+nf(second(),2)+"-"+"####.pdf"); // creates a file with a unique time stamp in the sketch directory
     }
     if (x >= width){            // if x has been reset then
       for (int i=0; i<10; i++){ // loop to load the stanza array
         stanza[i] = lines[int(random(lines.length))]; //select a random line to place in the stanza
         if (textWidth(stanza[i])>w){   // if this line is wider than the existing value for w
           w = textWidth(stanza[i]);    // will eventually assign the value of the widest line in the array
         }
         r[i] = random(255); // taking advantage of the loop that only resets when the composition has cleared to set some color values
         g[i] = random(255);
         b[i] = random(255);
       }
     }
     background (255); // fills the background of the compostion with white
     for (int i=0; i<10; i++){ // loop to create 10 shapes
       fill (r[i],g[i],b[i],random(128,150)); // creates random transluscency/tinting for each color each frame
       rect (xs[i],ys[i]+height*(i+1)/12,ws[i],hs[i], random(8,16),random(12,24),random(16,28),random(20,32)); // creates rectangles with rounded corners
     }
     fill(0);      // fills text color with opaque black
     for (int i=0; i<10; i++){           // each frame cycle through the stanza array
       textFont(f[i]);
       textSize(height/12+random(-1,1));
       text(stanza[i],x+random(-1,1),height*(i+1.5)/12+random(-1,1)); // and write the text to screen
     }
     x = x - 1;  // move horizontal position to the left one-half a unit/pixel
     if (x < -w){  // if horizontal position is further left than the longest line
       x = width;  // make new horizontal position off screen to the right
     }
     if (writePDF) {  // this chunk stops writing the PDF and is placed at the end of the frame
       writePDF = false;
       endRecord();
     }
}
 
void keyReleased(){ // this interface was suggested to me by Generative Gestaltung, ISBN: 978-3-87439-759-9
  if (key == 'f' || key == 'F') saveFrame("output/png/Re:mixer stanza - "+year()+"-"+nf(month(),2)+"-"+nf(day(),2)+"-"+nf(hour(),2)+"-"+nf(minute(),2)+"-"+nf(second(),2)+"-"+"####.png");
  if (key=='p' || key=='P') writePDF = true; // instructs sketch to write the next frame to a PDF file
}