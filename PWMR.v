///*

//module PWMR(
//input clock,
//input[7:0] PWMRval,
//output PWMR //motor "power" signal
////CurSense //wire for the two CurSenses
////input CurSense1,
////input CurSense2
//);
////assign CurSense = CurSense1 | CurSense2;

////StateMain u69 (.PWMR(PWMR));

//reg[20:0]counter;// 2^(num of bits) = 2,097,152
//reg[20:0]width; //width of pulse
//reg PWMtemp;

//    initial begin
//        counter = 0;
//        width = 0;
//        PWMtemp = 0;
//     end 
     
//     always@(posedge clock)begin
//        if(counter == 1666666) //resets the counter to 0 or increments
//            counter <= 0;
//         else
//            counter <= counter +1;
//        /*
//        if(CurSense == 1) begin
//            PWMtemp <= 0;
//        end
//        */   
//        //else 
//        if(counter < width) begin
//            PWMtemp <= 1;
//            end
            
//        else begin
//            PWMtemp <=0;
//         end     
//    end
////The above if/else sets the "power" to be on whenever counter is less
////  than width. The value for width is set based on SWpos below.
    
//    always@(posedge clock)begin
//        case(PWMRval)

//                //Syntax is this ->  (in the case that SWpos is this):(set width = ___)
//                //ON States
//                7'd0:width = 21'd0;         //0%
//                7'd5:width = 21'd83333;     //5%
//                7'd10:width = 21'd166666;   //10%
//                7'd15:width = 21'd249999;   //15%
//                7'd20:width = 21'd333333;   //20%
//                7'd25:width = 21'd416666;   //25%
//                7'd30:width = 21'd499999;   //30%
//                7'd35:width = 21'd583333;   //35%
//                7'd40:width = 21'd666666;   //40%
//                7'd45:width = 21'd749999;   //45%
//                7'd50:width = 21'd833333;   //50%
//                7'd55:width = 21'd916666;   //55%
//                7'd60:width = 21'd999999;   //60%
//                7'd65:width = 21'd1083333;  //65%
//                7'd70:width = 21'd1166666;  //70%
//                7'd75:width = 21'd1250000;  //75%
//                7'd80:width = 21'd1333333;  //80%
//                7'd85:width = 21'd1416666;  //85%
//                7'd90:width = 21'd1500000;  //90%
//                7'd95:width = 21'd1583333;  //95%
//                7'b100:width = 21'd1666665; //100%
                
//                /*
//                5'b00011:width = 21'd416666;//25% speed
//                5'b00101:width = 21'd416666;
//                5'b01001:width = 21'd416666;
//                5'b10001:width = 21'd416666;
                
//                5'b00111:width = 21'd833333; //50% speed
//                5'b01101:width = 21'd833333;
//                5'b11001:width = 21'd833333;
//                5'b10011:width = 21'd833333;
//                5'b10101:width = 21'd833333;
//                5'b01011:width = 21'd833333;
              
                
//                5'b01111:width = 21'd1250000; //75% speed
//                5'b11101:width = 21'd1250000;
//                5'b11011:width = 21'd1250000;
//                5'b10111:width = 21'd1250000;
                
//                5'b11111:width = 21'd1666665; //100%
//                default:width = 20'd0;
                
//                //So the reason its 5 bits is because 1 bit is used for a kill switch (SW1).
//                //I had it at 4 bits, but then I just changed it to 5 and added a 1
//                        //on the end for the ON states and a 0 for the off states.
//                */
//        endcase 

// end
        
// assign PWMR = PWMtemp;
    
//endmodule

///*
//module PWM(
//input clock,
//input CurSense1,
//input CurSense2,
//input[4:0] SWpos, //this starts at SW1 since we're using sw[0 for direction
//output PWM, //motor "power" signal
//CurSense
//    );

//assign CurSense = CurSense1 | CurSense2;
    
//reg[20:0]counter;// 2^(num of bits) = 2,097,152
//reg[20:0]width; //width of pulse
//reg PWMtemp;

//    initial begin
//        counter = 0;
//        width = 0;
//        PWMtemp = 0;
//     end 
     
//     always@(posedge clock)begin
//        if(counter == 1666666) //resets the counter to 0 or increments
//            counter <= 0;
//         else
//            counter <= counter +1;
//        if(CurSense == 1) begin
//            PWMtemp <= 0;
//        end
            
//        else if(counter < width) begin
//            PWMtemp <= 1;
//            end
            
//        else begin
//            PWMtemp <=0;
//         end     
//    end
////The above if/else sets the "power" to be on whenever counter is less
////  than width. The value for width is set based on SWpos below.
    
//    always@(posedge clock)begin
//        case(SWpos)

//                //Syntax is this ->  (in the case that SWpos is this):(set width = ___)
//                //ON States
//                5'b00001:width = 21'd0;
                
//                5'b00011:width = 21'd416666;//25% speed
//                5'b00101:width = 21'd416666;
//                5'b01001:width = 21'd416666;
//                5'b10001:width = 21'd416666;
                
//                5'b00111:width = 21'd833333; //50% speed
//                5'b01101:width = 21'd833333;
//                5'b11001:width = 21'd833333;
//                5'b10011:width = 21'd833333;
//                5'b10101:width = 21'd833333;
//                5'b01011:width = 21'd833333;
              
                
//                5'b01111:width = 21'd1250000; //75% speed
//                5'b11101:width = 21'd1250000;
//                5'b11011:width = 21'd1250000;
//                5'b10111:width = 21'd1250000;
                
//                5'b11111:width = 21'd1666665; //100%
//                default:width = 20'd0;
                
//                //So the reason its 5 bits is because 1 bit is used for a kill switch (SW1).
//                //I had it at 4 bits, but then I just changed it to 5 and added a 1
//                        //on the end for the ON states and a 0 for the off states.
//        endcase 

// end
        
// assign PWM = PWMtemp;
    
//endmodule
//*/