import processing.serial.*;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

Serial port;

float breadth = 1524;
float leng = 1097.28;
float pixel_bred = (breadth/500);
float pixel_leng = (leng/500);

ArrayList<Anchor> anchors = new ArrayList<Anchor>();
ArrayList<String> tags = new ArrayList<String>();
ArrayList<TAG_File> Tags_Data  = new ArrayList<TAG_File>();

String COM_PORT = "/dev/ttyUSB0";

int RSSI_threshold = -90; // At the max radius

byte[] header = new byte[50];
int byte_received = 0;
boolean error_status = true;
int crc = 0;
int payload_crc;

void setup()
{
  // User Input

  size(640, 640);
  background(255, 204, 0);
  port = new Serial(this, COM_PORT, 38400);

  // Anchor MAC Address Storage
  String File = "/home/kshitiz/sketchbook/Localisation_Using_RSSi/anchor.csv";
  BufferedReader br = null;
  String line = "";
  String cvsSplitBy = ",";


  try {
    br = new BufferedReader(new FileReader(File));
    while ((line = br.readLine()) != null) {
      String[] splited = line.split(cvsSplitBy);

      Anchor anchor_ref = new Anchor(splited[0], float(splited[1]), float(splited[2]));
      anchors.add(anchor_ref);
    }
  }
  catch (FileNotFoundException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  finally {
    if (br != null) {
      try {
        br.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  // TAG Address Storage
  File = "/home/kshitiz/sketchbook/Localisation_Using_RSSi/tag.csv";
  br = null;
  line = "";
  cvsSplitBy = ",";

  try {
    br = new BufferedReader(new FileReader(File));
    line = br.readLine();
    while (line != null) {
      String[] splited = line.split(cvsSplitBy);
      tags.add(splited[0]);
      line = br.readLine();
    }
  }
  catch (FileNotFoundException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  finally {
    if (br != null) {
      try {
        br.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  for (int i=0; i<tags.size(); i++)
  {
    //   println(tags.get(i));
    TAG_File tag_data_ref = new TAG_File(i);
    Tags_Data.add(tag_data_ref);
  }
}

void draw()
{
  serial2Event(port);
}

void serial2Event(Serial port)
{

  if (port.available()>0)
  {

    byte nByte = (byte)port.read();
    
    header[byte_received] = nByte;
    byte_received += 1 ;
    // println(hex(nByte));
    // println("Received:"+ byte_received);
    if (byte_received == 2)
    {
      if (header[0]==0x00 && header[1]==0x06)
      {
        error_status = true;
        println("Success0");
      } else
      {
        byte_received = 0;
        port.clear();
        error_status = false;      
        println("Failure0");
      }
    }

    if (byte_received <= 8 && error_status)
    {
      if (byte_received != 7)
        crc += header[byte_received-1];
      else
        crc += header[byte_received-1]<<8;
    }
  /*  if (byte_received == 8 && error_status)
    {
      if (crc != -257)
      {
        byte_received = 0;
        port.clear();
        error_status = false;
        println("Failure");
      } else
      {
        println("Success");
      }
      crc = 0;
    }
*/
    // To Be Checked
    if (byte_received >= 8 && error_status)
    {
      //  println("9Bit" + header[8]);
      if (byte_received == 9)
        payload_crc += header[byte_received-1]<<8;
      else
        payload_crc += header[byte_received-1];

      //  println(payload_crc);
    }

    if (byte_received == 41)
    {

      byte_received = 0;  
      String TAG_address = (hex(header[27]) + ":" + hex(header[28]) + ":" + hex(header[29]));
      String Anchor_address = (hex(header[17]) + ":" + hex(header[18]) + ":" + hex(header[19]));
      int RSSI = int(header[34])-256;
      //      println("Anchor_initial:"+Anchor_address);
      int index_tag = tags.indexOf(TAG_address);
      int index_anchor = 0;
      for (index_anchor=0; index_anchor<anchors.size(); index_anchor++)
      {
        Anchor anchor_ref = anchors.get(index_anchor);
        if ((Anchor_address).equals(anchor_ref.requestAnchorMAC()))
        {
          if (index_tag != -1) 
            (Tags_Data.get(index_tag)).addition(index_anchor, RSSI);
          //        println("Matched With:"+anchor_ref.requestAnchorMAC());
          break;
        }
      }
      if (index_tag != -1) 
      (Tags_Data.get(index_tag)).print();
    }
  }
}
