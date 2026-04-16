module ButtonShaper(in, clk, load,rst);  // load is B_out, in is B_in with respect to FSM
input wire in, clk,rst;      
output reg load;
parameter INIT=0, PULSE=1, WAIT=2;
reg [1:0] S, NS;
always@(S, in)
begin
case(S)
	INIT:
	  begin
	  load=1'b0;
	  if(in==0)
		NS=PULSE;
	  else
		NS=INIT;
	  end
	PULSE:
	  begin
	  load=1'b1;
	  NS=WAIT;
	  end
	WAIT:
	  begin
	load=1'b0;
	if(in==0)
	NS=WAIT;
	else if(in==1'b1)
	NS= INIT;
	  end
endcase
end

always@(posedge clk)
begin
if(rst==0)
S<=INIT;
else
S<=NS;
end
endmodule
