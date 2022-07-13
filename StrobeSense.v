/*
module StrobeSense(
input clock,
input StrobeIn,
output reg [1:0] strobe = 2'b00
//output reg [2:0] LED = 3'b000
);
 reg [27:0] StrobeCounter = 0;
 //reg [27:0] delay_counter = 0;
 reg [10:0]morse = 11'b00000000000;
 reg flip = 0;
 parameter GO = 11'b11101110100, STOP = 11'b10101000000, PAUSE = 11'b10111011101, RESUME = 11'b10111010000;


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
               RESUME: 
                    begin
                    strobe <= 2'b11;
                   // LED <= 3'b001;
                    morse <= 0;
                    end
               STOP:
                    begin
                    strobe <= 2'b00;
                    //LED <= 3'b000;
                    morse <= 0;
                    end
               PAUSE:
                    begin
                    strobe <= 2'b01;
                    //LED <= 3'b010;
                    morse <= 0;
                    end
               GO:
                    begin
                    strobe <= 2'b10;
                   // LED <= 3'b111;
                    morse <= 0;
                    end
                    
                    default begin
                    //morse = morse;
                    strobe = 2'b10;
                    end
     endcase
            
    end
 
endmodule

*/