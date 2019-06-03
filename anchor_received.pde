public class anchor_received
{
 private int index;
 private int RSSI;
 public float weight;
 public float X_Cor;
 public float Y_Cor;
  
 anchor_received(int index , int RSSI)
 {
  this.index = index;
  this.RSSI = RSSI;
  Anchor anchor_ref=anchors.get(index);
  X_Cor = anchor_ref.Anchor_XCor();
  Y_Cor = anchor_ref.Anchor_YCor();
 }
  
 public int indexRequest()
 {
  return(index); 
 }
 
 public int RSSIRequest()
 {
   return(RSSI);   
 }
 
 public void print()
 {
   println("Index Anchor:" + (anchors.get(index)).requestAnchorMAC());
   println("RSSI:" + RSSI);
   println("Weights: " + weight);
 }
}
