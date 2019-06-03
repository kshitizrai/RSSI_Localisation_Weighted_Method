public class TAG_File {

  private int index;
  private ArrayList<anchor_received> connected = new ArrayList<anchor_received>();
  private float x_est = 0;
  private float y_est = 0;
  TAG_File(int x)
  {
    this.index= x;
  }

  public void addition(int anchor_index, int RSSI)
  {
    anchor_received ref = new anchor_received(anchor_index, RSSI);
    int i=0;
    int flag=0;
    for (i=0; i<connected.size(); i++)
    {
      anchor_received ref2 = connected.get(i);
      //   println("Ref :"+ ref2.indexRequest()+" New :"+ anchor_index + " index :" + i);
      if (ref2.indexRequest() == anchor_index)
      {
        //     println("Match");
        connected.set(i, ref);
        //     println("Anchor_Connected Before :-" + connected.size()); 
        flag=1;
        break;
      }
    }
    if (flag == 0)
      connected.add(ref);

    sorting();
    if (connected.size()>=3)
    {
      calculate_weight();
    }
  }
  
  private  void calculate_weight()
  {
   color Tag_color = color(255,204,0);
   fill(Tag_color);
   stroke(255, 204, 0);
   ellipse(x_est/pixel_bred , y_est/pixel_leng , 20 ,20);
   
    x_est = 0;
    y_est = 0;
    int max = (connected.get(0)).RSSIRequest();
    for(int i=0 ;  i<connected.size() ; i++)
   {
     int RSSI_ref = (connected.get(i)).RSSIRequest();
     float weight = 2-float(max-RSSI_ref)/(max-RSSI_threshold);
     (connected.get(i)).weight = weight;
   }
   int weight_sum = 0;
   for(int i=0 ; i<connected.size() ; i++)
   {
    x_est += ((connected.get(i)).weight)*(connected.get(i).X_Cor);
    y_est += ((connected.get(i)).weight)*(connected.get(i).Y_Cor);
    weight_sum += (connected.get(i)).weight;
   }
   x_est = (x_est)/weight_sum;
   y_est = (y_est)/weight_sum;
   
   Tag_color = color(0,255,0);
   fill(Tag_color);
   ellipse(x_est/pixel_bred , y_est/pixel_leng , 20 ,20);
  }
  
  private void sorting()
  {
    for (int i=0; i<connected.size()-1; i++)
    {
      for (int j=0; j<connected.size()-i-1; j++)
      {
        if ((connected.get(j)).RSSIRequest() < (connected.get(j+1)).RSSIRequest())
        {
       //   println("Replaced");
          anchor_received temp = connected.get(j);
          connected.set(j, connected.get(j+1));
          connected.set(j+1, temp);
        }
      }
    }
  }

  public void print()
  {  
    println("Index Tag: " + tags.get(index));
    for (int i=0; i<connected.size(); i++)
    {
      (connected.get(i)).print();
    }
    println("X estimate : " + x_est);
    println("Y estimate : " + y_est);
    println("*******************\n");

  }

  public void Anchor_Connected()
  {
    println("Anchor_Connected :-" + connected.size());
  }
}
