/* The purpose of this adder module is to add the numbers
entered by two players and display the sum in the form of 7 segment display.
It takes in 2 four bit inputs and adds them and gives out the result of the 
sum in the form of its corressponding 7 segment display

Sarmad Akram Mohammed, UH ID: 2363756
*/

module adder(in1, in2, out);
    input  wire [3:0] in1;
    input  wire [3:0] in2;
    output reg  [6:0] out;
    reg [4:0] temp;
    always @(in1, in2) 
	begin
        temp = in1 + in2;

        case(temp)
            5'b00000: out = 7'b1000000; // 0
            5'b00001: out = 7'b1111001; // 1
            5'b00010: out = 7'b0100100; // 2
            5'b00011: out = 7'b0110000; // 3
            5'b00100: out = 7'b0011001; // 4
            5'b00101: out = 7'b0010010; // 5
            5'b00110: out = 7'b0000010; // 6
            5'b00111: out = 7'b1111000; // 7
            5'b01000: out = 7'b0000000; // 8
            5'b01001: out = 7'b0011000; // 9
            5'b01010: out = 7'b0001000; // A
            5'b01011: out = 7'b0000011; // b
            5'b01100: out = 7'b1000110; // C
            5'b01101: out = 7'b0100001; // d
            5'b01110: out = 7'b0000110; // E
            5'b01111: out = 7'b0001110; // F
            default: out = 7'b1111111; // (all segments off)
        endcase
    end
endmodule
