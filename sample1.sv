/*The Task: Implement a single-stage pipeline register in SystemVerilog using a standard valid/ready handshake. 
The Logic: The module sits between an input and output interface, accepts data when in_valid and in_ready are asserted, presents stored data on the output with out_valid, and correctly handles backpressure without data loss or duplication. 
The design should be fully synthesizable and reset to a clean, empty state.
*/
module sample1 #(
    parameter N = 32
)(
    input logic clk,
    input logic rst_n,
    
    input logic in_valid,
    input logic in_ready,
    input logic [N-1:0] in_data,
    
    output logic out_valid,
    output logic out_ready,
    output logic [N-1:0] out_data
);

    // Internal storage for the pipeline register
    logic [N-1:0] data_reg;
    logic valid_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
            data_reg <= {N{1'b0}};
        end 
        else begin
            if (in_valid && in_ready) begin
                data_reg <= in_data;
                valid_reg <= 1'b1;
            end
            if (out_ready && valid_reg) begin
                valid_reg <= 1'b0;
            end
        end
    end

    assign out_ready = (in_ready && in_valid) || !valid_reg;
    assign out_valid = valid_reg;
    assign out_data = data_reg;

endmodule