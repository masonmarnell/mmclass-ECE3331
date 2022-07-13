// Adopted from Rice's 2 process Mealy machine

//MERGED WITH StrobeSense, DISP, PWM, ColorSense

//Ended up only working if all in the same module
module StateMain(
     input clock,
     input StrobeIn,
     output reg [1:0] strobe = 2'b10,
     input LDistIn,
     input RDistIn,
     output reg [15:0] LED = 0,
     output reg IN1,
     output reg IN2,
     output reg IN3,
     output reg IN4,
     output PWM,
     //ColorSense
     input colorsense,//input from color sensor
     output reg [1:0] filter_select = 2'b00, // 00:red, 01:blue, 10:clear, 11:green reg [1:0][S2:S3]
     output reg [2:0] color_out = 3'b000,
     //Disp
     output reg [3:0] an,
     output reg [6:0] seg
     );
     

parameter S0 = 0, //stop
          S1 = 1, //pause
          S2 = 2, //drive forward
          S3 = 3, //turn right (sense left)
          S4 = 4; //turn left  (sense right)

reg [3:0] state = S0;
reg [30:0] TurnCounter = 0;

//StrobeSense:

reg [27:0] StrobeCounter = 0;
reg [10:0]morse = 11'b00000000000;
reg flip = 0;
parameter GO = 11'b11101110100, STOP = 11'b10101000000, PAUSE = 11'b10111011101, RESUME = 11'b10111010000;

//Strobe variable:
//00 Stop
//01 Pause
//10 Go
//11 Resume 

       
     always @ (posedge clock) begin
          
          case(state)
               S0: //stop
                    if(strobe==2'b10) begin //if go strobe
                        state <= S2; //drive forward state  
                    end
                    else begin
                        
                        LED[14] <=0;
                        LED[13] <=0;
                        LED[12] <=0;
                        LED[11] <=0;                   
                        LED[15] <= 1; //state indication
                        
                        IN1 <= 1;
                        IN3 <= 0;
                        IN2 <= 0;
                        IN4 <= 1;
                        PWMVal <= 0;
                    end
                    
               S1: //pause
                    if(strobe==2'b11) begin //if resume strobe
                        state <= S2; //drive forward state
                    end
                    else begin
                        
                        LED[15] <=0;
                        LED[13] <=0;
                        LED[12] <=0;
                        LED[11] <=0;
                        LED[14] <= 1; //state indication
                        
                        IN1 <= 1;
                        IN3 <= 0;
                        IN2 <= 0;
                        IN4 <= 1;
                        PWMVal <= 0;
                    end
                    
               S2: //drive forward state
                    if(strobe==2'b00) begin   //go to stop
                        state <= S0; 
                    end
                    else if(strobe==2'b01) begin
                        state <= S1; //go to pause
                    end
                    else if(LDistIn==1) begin
                        state <= S3; //go to turn right
                    end
                    else if(RDistIn==1) begin
                        state <= S4; //go to turn left
                    end
                    else begin
                        LED[15] <=0;
                        LED[14] <=0;
                        LED[12] <=0;
                        LED[11] <=0;      
                        LED[13] <= 1; //state indication
                        
                        IN1 <= 1;
                        IN2 <= 0;
                        IN3 <= 0;
                        IN4 <= 1;
                        PWMVal <= 50;
                    end
                    
                 S3://turn right state
                        if(1) begin
                        
                        LED[15] <=0;
                        LED[14] <=0;
                        LED[13] <=0;
                        LED[11] <=0;
                        LED[12] <= 1; //state indication
                        
                        IN1 <= 0;
                        IN2 <= 1;
                        IN3 <= 0;
                        IN4 <= 1;
                        PWMVal <= 35;
                        
                        //------------------------------------------------------
                        //Math for the turn: # of seconds = (value) / 100,000,000
                        if(TurnCounter>=140000000) begin // # of clock cycles we want the turn to stop at
                             TurnCounter <= 0; //resets counter
                             state <= S2; //goes to drive forward state
                             end
                        else begin
                             TurnCounter <= TurnCounter +1; 
                             end  
                        //---------------------------------------------------------
                         end
                 
                 S4://turn left state
                        
                        if(1) begin
                        
                        LED[15] <=0;
                        LED[14] <=0;
                        LED[13] <=0;
                        LED[12] <=0;
                        LED[11] <= 1; //state indication
                        
                        IN1 <= 1;
                        IN2 <= 0;
                        IN3 <= 1;
                        IN4 <= 0;
                        PWMVal <= 35;
                        
                        //----------------------------------------------------
                        //Math for the turn: # of seconds = (value) / 100,000,000
                        if(TurnCounter>=140000000) begin // # of clock cycles we want the turn to stop at
                             TurnCounter <= 0; //resets counter
                             state <= S2; //goes to drive forward state
                             end
                        else begin
                             TurnCounter <= TurnCounter +1; 
                             end  
                        //-----------------------------------------------------
                         end
                        
                 
          endcase
          
          end
          //assign state = state_temp; //might should change this back if getting errors

//----------------------------------------------------------------------------------------------------------------------------------------------


always@(posedge clock) begin
    if(StrobeCounter > 9999999)// (10M) for 200 ms input signal (7.5 M for 150 ms, 5M for 100 ms)
         begin
            StrobeCounter <= 0;
            flip = !flip;
         end 
    else
            StrobeCounter <= StrobeCounter + 1;
 end


    always@ (posedge flip) begin
    
            morse = morse << 1; 
            morse[0] = StrobeIn;
            
            case(morse)
               STOP:
                    begin
                    strobe <= 2'b00;
                    LED[10:9] <= 2'b00;
                    morse <= 0;
                    end
               PAUSE:
                    begin
                    strobe <= 2'b01;
                    LED[10:9] <= 2'b01;
                    morse <= 0;
                    end

               GO:
                    begin
                    strobe <= 2'b10;
                    LED[10:9] <= 2'b10;
                    morse <= 0;
                    end
               RESUME: 
                    begin
                    strobe <= 2'b11;
                    LED[10:9] <= 2'b11;
                    morse <= 0;
                    end
                                      
                    default begin
                    //morse = morse;
                    //strobe = 2'b10;
                    end
     endcase
            
end

//----------------------------------------------------------------------------------------------------------------------------------------------

reg[20:0]counter;// 2^(num of bits) = 2,097,152
reg[20:0]width; //width of pulse
reg PWMtemp;
reg [7:0] PWMVal = 0;

    initial begin
        counter = 0;
        width = 0;
        PWMtemp = 0;
     end 
     

always@(posedge clock)begin
        if(counter == 1666666)
            counter <= 0;
         else
            counter <= counter +1;
        if(counter < width) begin
            PWMtemp <= 1;
            end 
        else begin
            PWMtemp <=0;
         end     
    end
    
    always@(posedge clock)begin
        case(PWMVal)

                //Syntax is this ->  (in the case that SWpos is this):(set width = ___)
                //ON States
                7'd0:width = 21'd0;         //0%
                7'd5:width = 21'd83333;     //5%
                7'd10:width = 21'd166666;   //10%
                7'd15:width = 21'd249999;   //15%
                7'd20:width = 21'd333333;   //20%
                7'd25:width = 21'd416666;   //25%
                7'd30:width = 21'd499999;   //30%
                7'd35:width = 21'd583333;   //35%
                7'd40:width = 21'd666666;   //40%
                7'd45:width = 21'd749999;   //45%
                7'd50:width = 21'd833333;   //50%
                7'd55:width = 21'd916666;   //55%
                7'd60:width = 21'd999999;   //60%
                7'd65:width = 21'd1083333;  //65%
                7'd70:width = 21'd1166666;  //70%
                7'd75:width = 21'd1250000;  //75%
                7'd80:width = 21'd1333333;  //80%
                7'd85:width = 21'd1416666;  //85%
                7'd90:width = 21'd1500000;  //90%
                7'd95:width = 21'd1583333;  //95%
                7'b100:width = 21'd1666665; //100%
              
        endcase 

 end
        
 assign PWM = PWMtemp;

//----------------------------------------------------------------------------------------------------------------------------------------------

reg sig_dly = 0;
reg [20:0] freq_count = 0;//this is the count of posedges in every .10 second period
reg [26:0] clr_counter = 0; //this is the counter for the time period
reg enable = 1;
reg done = 0;
reg all_filters_done = 0;
reg [20:0] frequency = 0;
reg [1:0] filter_count = 0;
reg [20:0] red_freq = 0;
reg [20:0] blue_freq = 0;
reg [20:0] clear_freq = 0;
reg [20:0] green_freq = 0;
wire pe; 


initial begin
        clr_counter = 0;
        freq_count = 0;
        frequency = 0;
end 

always @(posedge clock) sig_dly <= colorsense; 

assign pe = colorsense & ~sig_dly;

always @ (posedge clock)
          if(~enable) 
          begin
               frequency = 0;
               freq_count = 0;
               clr_counter = 0;
               done = 0;
          end
          else begin
               if (clr_counter < 5000000)//5M (50,000 for tb)
               begin
                    clr_counter <= clr_counter + 1;

                    if(pe)
                    begin
                        freq_count <= freq_count + 1;
                    end
               end
               else begin
                    frequency = 0;
                    frequency = freq_count * 20;
                    freq_count = 0;
                    clr_counter = 0;
                    done = 1;
                    filter_count = filter_count +1;
               end
          end


always @ (posedge clock)
begin
            case(filter_count)
                    1: 
                        begin
                        if (done)
                        begin
                            filter_select <= 2'b01; //blue filter
                            //LED <= 4'b0001;
                            red_freq <= frequency;
                            enable <= 0;
                        end
                        else enable <= 1;
                        end
                    2: 
                        begin
                        if (done)
                        begin
                            filter_select <= 2'b10;//clear filter
                            //LED <= 4'b0010;
                            blue_freq <= frequency;
                            enable <=0;
                        end
                        else enable <= 1;
                        end
                    3: 
                        begin
                        if (done)
                        begin
                            filter_select <= 2'b11;//green filter
                            //LED <= 4'b0100;
                            clear_freq <= frequency;
                            enable <=0;
                        end
                        else enable <= 1;
                        end
                    0:
                        begin
                        if (done)
                        begin
                            filter_select <= 2'b00; //red filter
                            //LED <= 4'b1000;
                            green_freq <= frequency;
                            enable <= 0;
                            all_filters_done <= 1;
                        end
                        else enable <= 1;
                        end
                    default:
                        begin
                            //filter_count <= filter_count; 
                            enable <= enable;
                        end
            endcase
            
    if (all_filters_done)//200ms
    begin
           //code for comparing frequency values of red, blue, clear, green and setting color_out to the respective color
        
        if (red_freq < 4500 && blue_freq < 4500 && clear_freq < 9000 && green_freq < 4200)
            begin
                color_out = 3'b000;  //ground
            end
            else if (green_freq > (red_freq - 1000) && green_freq > (blue_freq - 500))
            begin
                if ((green_freq > 6000))//&&(blue_freq < 5000)&&(red_freq > 3000)
                color_out = 3'b100;//try upping this value to 6-7k
            end
            else if (red_freq > blue_freq && red_freq > green_freq)
            begin
                if ((red_freq > 9000)&&(green_freq < 7000)&&(blue_freq < 7000)) //8000,6000,7000
                color_out = 3'b001;
            end                             
            else if (blue_freq > red_freq && blue_freq > green_freq)
            begin
                if ((blue_freq > 6500)&&(red_freq < 5000))//&&(green_freq < 6000)&&(red_freq < 5000)
                color_out = 3'b010;
            end 
            else 
            begin
                color_out = 3'b000;//experiment with setting color_out directly vs. double check method
            end
      

        all_filters_done = 0;
        enable <= 1;//??

    end
end

//----------------------------------------------------------------------------------------------------------------------------------------------
//DISP Module

 reg [18:0] count;
 always @ (posedge clock)
 count = count + 1;

     wire [1:0] refresh;
     assign refresh = count[18:17];

     reg [1:0] DispState = 0; 
     reg [30:0] DispCounter = 0; //counter value used for leaving the display on for a certain number of clocks
     reg [30:0] FlickerCounter = 0; //counter value used for flicker compensation
     reg [2:0] LatentDispColor = 000; //used to store color so that the second always@ works
     
     //-------------------------------------------------------------------------------------
     always @ (posedge clock)begin //delay counter
        case(DispState)
            0:
                    if(color_out==3'b001||color_out==3'b010||color_out==3'b100) begin
                        LatentDispColor = color_out;
                        DispState = 1;
                    end
                    else begin
                        DispState<=0;
                    end
            1:
                        if(1) begin
                        // more code could go here
                        if(FlickerCounter>=20000000) begin //20M is the time it takes for a cycle of 
                        //old value was 25000000 for .25 seconds
                             
                             if(color_out==3'b001||color_out==3'b010||color_out==3'b100) begin
                                LatentDispColor = color_out;
                                DispState =2;
                                
                             end
                             
                             else begin
                             FlickerCounter <= 0; //resets counter
                             DispState <= 0;
                             end
                             
                             end
                        else begin
                             FlickerCounter <= FlickerCounter +1;
                             //DispActivator <= 1; 
                             end  
                                               end
            2:      
                    if(1) begin
                        //more code could go here
                        if(DispCounter>=200000000) begin //change how long the display stays on here
                             DispCounter <= 0; //resets counter
                             LatentDispColor <= 0;
                             DispState <= 0;
                             
                             end
                        else begin
                             DispCounter <= DispCounter +1;
                             
                             //DispActivator <= 1; 
                             end  
                         end
            
            
        endcase
     end
     
    
     //------------------------------------------------------------------------------------------------
    

     
     
     always @ (posedge clock)begin
     if ((strobe==2'b10 || strobe==2'b11) && (DispState==2 && LatentDispColor==3'b001))begin //red
          case(refresh)
          2'b00:
               begin
                    an = 4'b0111;
                    seg = 7'b0101111;
               end
          2'b01:
               begin
                    an = 4'b1011;
                    seg = 7'b0000110;//Nothing
               end
          2'b10:
               begin
                    an = 4'b1101;
                    seg = 7'b0100001;
               end
          2'b11:
               begin
                    an = 4'b1110;
                    seg = 7'b1111111;//Nothing
               end
          endcase
          end
       else if ((strobe==2'b10 || strobe==2'b11) && (DispState==2 && LatentDispColor==3'b010))begin //blue
          case(refresh)
          2'b00:
               begin
                    an = 4'b0111;
                    seg = 7'b0000011;
               end
          2'b01:
               begin
                    an = 4'b1011;
                    seg = 7'b1000111;
               end
          2'b10:
               begin
                    an = 4'b1101;
                    seg = 7'b1100011;
               end
          2'b11:
               begin
                    an = 4'b1110;
                    seg = 7'b0000110;
               end
          endcase
          end
        else if ((strobe==2'b10 || strobe==2'b11) && (DispState==2 && LatentDispColor==3'b100))begin //green
          case(refresh)
          2'b00:
               begin
                    an = 4'b0111;
                    seg = 7'b0010000;
               end
          2'b01:
               begin
                    an = 4'b1011;
                    seg = 7'b0101111;
               end
          2'b10:
               begin
                    an = 4'b1101;
                    seg = 7'b0101011;
               end
          2'b11:
               begin
                    an = 4'b1110;
                    seg = 7'b1111111;
               end
          endcase
          end
          
          else begin
          case(refresh)
          2'b00:
               begin
                    an = 4'b0111;
                    seg = 7'b0000000;
               end
          2'b01:
               begin
                    an = 4'b1011;
                    seg = 7'b0000000;
               end
          2'b10:
               begin
                    an = 4'b1101;
                    seg = 7'b0000000;
               end
          2'b11:
               begin
                    an = 4'b1110;
                    seg = 7'b0000000;
               end
          endcase
          end
       
      end

//----------------------------------------------------------------------------------------------------------------------------
endmodule