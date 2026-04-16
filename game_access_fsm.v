module game_access_fsm(
    input  wire clk,
    input  wire rst,
    input  wire b_in,
    input  wire [3:0] in,
    input  wire log_out,
    input  wire timer_done,

    output reg loggedout,
    output reg loggedin
);

parameter digit1       = 0,
          digit2       = 1,
          digit3       = 2,
          digit4       = 3,
          verify0_set  = 4,
          verify0_cap  = 5,
          verify1_set  = 6,
          verify1_cap  = 7,
          verify2_set  = 8,
          verify2_cap  = 9,
          verify3_set  = 10,
          verify3_cap  = 11,
          pass_state   = 12;

reg [3:0] d1, d2, d3, d4;
reg [3:0] rom_d0, rom_d1, rom_d2, rom_d3;

reg [3:0] state;
reg [1:0] rom_addr;
wire [3:0] rom_data;

// Quartus ROM (registered output)
ROM_PSWD passmem (
    .address({3'b000, rom_addr}),
    .clock(clk),
    .q(rom_data)
);

always @(posedge clk) begin
    if (!rst) begin
        state     <= digit1;
        loggedout <= 1;
        loggedin  <= 0;

        d1 <= 0; d2 <= 0; d3 <= 0; d4 <= 0;
        rom_d0 <= 0; rom_d1 <= 0; rom_d2 <= 0; rom_d3 <= 0;
        rom_addr <= 0;
    end 
    else begin
        case (state)

        
        digit1: if (b_in) begin d1 <= in; state <= digit2; end
        digit2: if (b_in) begin d2 <= in; state <= digit3; end
        digit3: if (b_in) begin d3 <= in; state <= digit4; end
        digit4: if (b_in) begin
            d4 <= in;
            rom_addr <= 0;
            state <= verify0_set;
        end

        
        // ROM READ 
        
        verify0_set: begin rom_addr <= 0; state <= verify0_cap; end
        verify0_cap: begin rom_d0 <= rom_data; state <= verify1_set; end

        verify1_set: begin rom_addr <= 1; state <= verify1_cap; end
        verify1_cap: begin rom_d1 <= rom_data; state <= verify2_set; end

        verify2_set: begin rom_addr <= 2; state <= verify2_cap; end
        verify2_cap: begin rom_d2 <= rom_data; state <= verify3_set; end

        verify3_set: begin rom_addr <= 3; state <= verify3_cap; end
        verify3_cap: begin
            rom_d3 <= rom_data;

            if (d1 == rom_d0 &&
                d2 == rom_d1 &&
                d3 == rom_d2 &&
                d4 == rom_d3)
                state <= pass_state;
            else
                state <= digit1;
        end

        
        pass_state: begin
            loggedout <= 0;
            loggedin  <= 1;

            
            if (timer_done && log_out) begin
                state       <= digit1;
                loggedout   <= 1;
                loggedin    <= 0;

                
                d1 <= 0; d2 <= 0; d3 <= 0; d4 <= 0;
                rom_addr <= 0;
            end
            else begin
                
                state <= pass_state;
            end
        end

        endcase
    end
end

endmodule


