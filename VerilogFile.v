//Top Module
module VerilogFile(
input SW0,
input SW1,
input clock,
output IN1,
output IN2,
output IN3,
output IN4,
output PWMA,
output PWMB,
output [15:0] LED,
output[3:0] an,
output[6:0] seg,
input LDistIn,
input RDistIn,
input StrobeIn,
output [1:0]filter_select,
input colorsense,
output [2:0] color_out
);

StateMain u4(.clock(clock),.IN1(IN1),.IN2(IN2),.IN3(IN3),.IN4(IN4),.LDistIn(LDistIn),.RDistIn(RDistIn),.LED(LED),.StrobeIn(StrobeIn),.PWM(PWMA),
.filter_select(filter_select),.colorsense(colorsense),.color_out(color_out),.an(an),.seg(seg));

assign PWMB = PWMA;

endmodule