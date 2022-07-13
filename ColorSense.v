// merged color_sense program

// Andrew Stelluti ; Project Lab 1
// Create Date: 03/20/2021

// Sources Used: frequency counter is taken from Rice Rodriguez' GitHub example code

// Description: This module counts a the frequency input while changing the color filters
// on the TCS3200 color sensor. The values of the frequency for each color filter are compared.
// the output "color_out" corresponds to which color filter yields the highest frequency

//////////////////////////////////////////////////////////////////////////////////

/*

module ColorSense(
input colorsense,//input from color sensor
input clock,
output reg [1:0] filter_select = 2'b00, // 00:red, 01:blue, 10:clear, 11:green reg [1:0][S2:S3]
output reg [3:0] LED = 4'b0000,
output reg [2:0] color_out = 3'b000
);

reg sig_dly = 0;
reg [20:0] freq_count = 0;//this is the count of posedges in every .10 second period
reg [26:0] counter = 0; //this is the counter for the time period
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

//reg [2:0] color_out = 3'b000; //000:ground, 001:red, 010:blue, 011:clear, 100:green
reg [2:0] color_out2 = 3'b000;


initial begin
        counter = 0;
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
               counter = 0;
               done = 0;
          end
          else begin
               if (counter < 5000000)//5M (50,000 for tb)
               begin
                    counter <= counter + 1;

                    if(pe)
                    begin
                        freq_count <= freq_count + 1;
                    end
               end
               else begin
                    frequency = 0;
                    frequency = freq_count * 20;
                    freq_count = 0;
                    counter = 0;
                    done = 1;
                    filter_count = filter_count +1;
               end
          end


always @ (posedge clock)
begin
            case(filter_count)//try experimenting with setting filter_count within the cases and removing the need of a counter ++1 in the freq_counter !
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
                    default: // pretty sure this never executes
                        begin
                            filter_count <= filter_count; 
                            enable <= enable;
                        end
            endcase
            
    if (all_filters_done)
    begin
           //code for comparing frequency values of red, blue, clear, green and setting color_out to the respective color

        if (red_freq < 4200 && blue_freq < 4200 && clear_freq < 6000 && green_freq < 4200) color_out = 3'b000;//ground
        else if (red_freq > blue_freq && red_freq > green_freq) color_out = 3'b001;//red
        else if (blue_freq > red_freq && blue_freq > green_freq) color_out = 3'b010;//blue
        else if (green_freq > red_freq && green_freq > blue_freq) color_out = 3'b100;//green
        else color_out = 3'b000;


        all_filters_done = 0;
        enable <= 1;//??

    end
end

endmodule

*/