public class MessageDecode{
   private String Anchor_Address;
   private String Tag_Address;
   private int RSSI;
   private String Message_Received;
   
  MessageDecode(String Message) {
   this.Message_Received = Message;
   if(decode())
     println("Success");
   else
     println("Failure");
  }   
    
  public boolean decode()
  {
    String decoded[] = this.Message_Received.split(",");
    Anchor_Address = decoded[0] ;
    Tag_Address = decoded[1] ;
    RSSI = int(decoded[2]); 
    if(check())
    {
      return(true);
    }
    return(false);
  }
  
  private boolean check()
  {
    for(int i=0 ; i<anchors.size() ; i++)
    {
      Anchor anchor_ref = anchors.get(i);
      String address = anchor_ref.requestAnchorMAC();
      if(Anchor_Address.equals(address))
       {
        return(true);
       }
    }
    return(false);
  }
  
  public String TagRequest()
  {
   return(Tag_Address); 
  }
  
  public String AnchorRequest()
  {
   return(Anchor_Address); 
  }
  
  public int RSSIRequest()
  {
   return(RSSI); 
  }
  
  public void print()
  {
   println(Message_Received);
   println(Anchor_Address + " " + Tag_Address + " " + RSSI + " ");
  }
}
