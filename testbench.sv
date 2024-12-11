module DualLift_Tb();
    logic clk, reset;
    logic [2:0] req_floor1, req_floor2; // Independent requests for Lift 1 and Lift 2
    logic emergency_stop1, emergency_stop2;
    logic full_capacity1, full_capacity2; // Weight sensor signals
    logic [1:0] door1, door2;             // Door statuses
    logic [2:0] current_floor1, current_floor2; // Current floors
    logic [7:0] requests1, requests2;     // Request status

    // Instantiate the DualLift module
    DualLift dut(
        .clk(clk),
        .reset(reset),
        .req_floor1(req_floor1),
        .req_floor2(req_floor2),
        .emergency_stop1(emergency_stop1),
        .emergency_stop2(emergency_stop2),
        .full_capacity1(full_capacity1),
        .full_capacity2(full_capacity2),
        .door1(door1),
        .door2(door2),
        .current_floor1(current_floor1),
        .current_floor2(current_floor2),
        .requests1(requests1),
        .requests2(requests2)
    );

    // Clock generation with a period of 50 time units (to avoid overlap)
    initial clk = 0;
    always #50 clk = ~clk;

    // Test stimulus
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, DualLift_Tb);

        // Initialize signals
        reset = 1; 
        emergency_stop1 = 0; 
        emergency_stop2 = 0; 
        full_capacity1 = 0; 
        full_capacity2 = 0;
        req_floor1 = 3'bx; 
        req_floor2 = 3'bx;

        #50 reset = 0; // Align with clock period

        // Test Case 1: Simple Requests
        #50 req_floor1 = 3; // Lift 1: Request floor 3
        #50 req_floor2 = 4; // Lift 2: Request floor 6
        #50 req_floor1 = 6; // Lift 1: Request floor 2
        #50 req_floor2 = 5; // Lift 2: Request floor 5

        // Test Case 2: Emergency Stop for Lift 1
        #100 emergency_stop1 = 1; // Activate emergency stop for Lift 1
        #100 emergency_stop1 = 0;  // Deactivate emergency stop for Lift 1

        // Test Case 3: Full Capacity for Lift 2
        #150 full_capacity2 = 1; // Lift 2 at full capacity
      #50 req_floor1 = 7;
       // #50 req_floor2 = 7; // Request ignored due to full capacity
        #100 full_capacity2 = 0; // Lift 2 no longer at full capacity
        #50 req_floor2 = 7; // Request floor 7 now accepted

       
      
        #700 $finish;
    end

    // Monitor output
    initial begin
        $display("\n===========================================================");
        $display("Time\tclk\treset\treq1\tcf1\tr1\td1\tE-Stop1\tFull-Cap1\t| req2\tcf2\tr2\td2\tE-Stop2\tFull-Cap2");
        $display("===========================================================");
        $monitor("%0t\t%b\t%b\t%d\t%d\t%b\t%d\t%b\t%b\t| %d\t%d\t%b\t%d\t%b\t%b",
            $time, clk, reset, req_floor1, current_floor1, requests1, door1, emergency_stop1, full_capacity1,
            req_floor2, current_floor2, requests2, door2, emergency_stop2, full_capacity2);
    end

    // Custom logic to display requests in reverse order (floor 0 is MSB, floor 7 is LSB)
    always @* begin
        $display("Requests1 (in reverse): %b", {requests1[7], requests1[6], requests1[5], requests1[4], 
                                            requests1[3], requests1[2], requests1[1], requests1[0]});
        $display("Requests2 (in reverse): %b", {requests2[7], requests2[6], requests2[5], requests2[4], 
                                            requests2[3], requests2[2], requests2[1], requests2[0]});
    end
endmodule
