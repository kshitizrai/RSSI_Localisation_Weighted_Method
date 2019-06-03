public class Anchor  {
  private String Anchor_MAC;
  private float Anchor_X;
  private float Anchor_Y;
   private color Anchor_color = color(255,0,0);
   
  Anchor(String Anchor_MAC, float Anchor_X, float Anchor_Y)
  {
   this.Anchor_MAC = Anchor_MAC;
   this.Anchor_X = (Anchor_X);
   this.Anchor_Y = (Anchor_Y);
   fill(this.Anchor_color);
   ellipse(this.Anchor_X/pixel_bred , this.Anchor_Y/pixel_leng , 50 ,50);
  }
  
  public String requestAnchorMAC()
  {
    return(this.Anchor_MAC);
  }
  
  public float Anchor_XCor()
  {
   return(this.Anchor_X); 
  }
  
  public float Anchor_YCor()
  {
   return(this.Anchor_Y); 
  } 
  
  public void print()
  {
   println(Anchor_MAC + " " + Anchor_X + " " + Anchor_Y + "\n");  
  }
  
}
  
