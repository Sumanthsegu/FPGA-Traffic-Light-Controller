`timescale 1ns / 1ps

module traffic_light_controller #(
    parameter integer GREEN_TIME    = 5,
    parameter integer YELLOW_TIME   = 2,
    parameter integer ALL_RED_TIME  = 1,
    parameter integer CLK_FREQ_HZ   = 100_000_000
)(
    input  wire clk,
    input  wire reset,

    output reg roadA_red,
    output reg roadA_yellow,
    output reg roadA_green,

    output reg roadB_red,
    output reg roadB_yellow,
    output reg roadB_green
);

    // State encoding
    localparam [2:0]
        S_A_GREEN   = 3'b000,
        S_A_YELLOW  = 3'b001,
        S_ALL_RED_1 = 3'b010,
        S_B_GREEN   = 3'b011,
        S_B_YELLOW  = 3'b100,
        S_ALL_RED_2 = 3'b101;

    reg [2:0] state;
    reg [2:0] next_state;

    // Number of clock cycles required for each state
    localparam integer GREEN_COUNT   = CLK_FREQ_HZ * GREEN_TIME;
    localparam integer YELLOW_COUNT  = CLK_FREQ_HZ * YELLOW_TIME;
    localparam integer ALL_RED_COUNT = CLK_FREQ_HZ * ALL_RED_TIME;

    localparam integer COUNTER_WIDTH = 32;

    reg [COUNTER_WIDTH-1:0] counter;
    reg [COUNTER_WIDTH-1:0] state_limit;

    // State-dependent timing limit
    always @(*) begin
        case (state)
            S_A_GREEN:   state_limit = GREEN_COUNT - 1;
            S_A_YELLOW:  state_limit = YELLOW_COUNT - 1;
            S_ALL_RED_1: state_limit = ALL_RED_COUNT - 1;
            S_B_GREEN:   state_limit = GREEN_COUNT - 1;
            S_B_YELLOW:  state_limit = YELLOW_COUNT - 1;
            S_ALL_RED_2: state_limit = ALL_RED_COUNT - 1;
            default:     state_limit = GREEN_COUNT - 1;
        endcase
    end

    // Timer counter
    always @(posedge clk) begin
        if (reset)
            counter <= 0;
        else if (counter >= state_limit)
            counter <= 0;
        else
            counter <= counter + 1'b1;
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= S_A_GREEN;
        else if (counter >= state_limit)
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S_A_GREEN:   next_state = S_A_YELLOW;
            S_A_YELLOW:  next_state = S_ALL_RED_1;
            S_ALL_RED_1: next_state = S_B_GREEN;
            S_B_GREEN:   next_state = S_B_YELLOW;
            S_B_YELLOW:  next_state = S_ALL_RED_2;
            S_ALL_RED_2: next_state = S_A_GREEN;
            default:     next_state = S_A_GREEN;
        endcase
    end

    // Moore FSM output decoder
    always @(*) begin
        roadA_red    = 1'b0;
        roadA_yellow = 1'b0;
        roadA_green  = 1'b0;

        roadB_red    = 1'b0;
        roadB_yellow = 1'b0;
        roadB_green  = 1'b0;

        case (state)
            S_A_GREEN: begin
                roadA_green = 1'b1;
                roadB_red   = 1'b1;
            end

            S_A_YELLOW: begin
                roadA_yellow = 1'b1;
                roadB_red    = 1'b1;
            end

            S_ALL_RED_1: begin
                roadA_red = 1'b1;
                roadB_red = 1'b1;
            end

            S_B_GREEN: begin
                roadA_red   = 1'b1;
                roadB_green = 1'b1;
            end

            S_B_YELLOW: begin
                roadA_red    = 1'b1;
                roadB_yellow = 1'b1;
            end

            S_ALL_RED_2: begin
                roadA_red = 1'b1;
                roadB_red = 1'b1;
            end

            default: begin
                roadA_green = 1'b1;
                roadB_red   = 1'b1;
            end
        endcase
    end

endmodule
