`timescale 1ns / 1ps

module traffic_light_controller_tb;

    reg clk;
    reg reset;

    wire roadA_red;
    wire roadA_yellow;
    wire roadA_green;

    wire roadB_red;
    wire roadB_yellow;
    wire roadB_green;

    // Timing is intentionally scaled down for simulation.
    // The RTL is designed for a 100 MHz FPGA clock by default.
    traffic_light_controller #(
        .GREEN_TIME(5),
        .YELLOW_TIME(2),
        .ALL_RED_TIME(1),
        .CLK_FREQ_HZ(1)
    ) DUT (
        .clk(clk),
        .reset(reset),
        .roadA_red(roadA_red),
        .roadA_yellow(roadA_yellow),
        .roadA_green(roadA_green),
        .roadB_red(roadB_red),
        .roadB_yellow(roadB_yellow),
        .roadB_green(roadB_green)
    );

    // 10 ns clock period for simulation (100 MHz simulation clock).
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        #200;
        reset = 1'b0;

        // Run long enough to observe multiple complete FSM cycles.
        #1000;

        $finish;
    end

    // Console monitor
    initial begin
        $monitor(
            "Time=%0t | Reset=%b | A: R=%b Y=%b G=%b | B: R=%b Y=%b G=%b",
            $time,
            reset,
            roadA_red,
            roadA_yellow,
            roadA_green,
            roadB_red,
            roadB_yellow,
            roadB_green
        );
    end

    // Safety checks
    always @(posedge clk) begin
        if (roadA_green && roadB_green)
            $error("Both roads are GREEN at time %0t", $time);

        if ((roadA_red + roadA_yellow + roadA_green) > 1)
            $error("Multiple Road A lights are ON at time %0t", $time);

        if ((roadB_red + roadB_yellow + roadB_green) > 1)
            $error("Multiple Road B lights are ON at time %0t", $time);
    end

endmodule
