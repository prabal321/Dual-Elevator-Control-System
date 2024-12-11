module DualLift(
    input logic clk, reset,
    input logic [2:0] req_floor1, req_floor2,
    input logic emergency_stop1, emergency_stop2,
    input logic full_capacity1, full_capacity2,
    output logic [1:0] door1, door2,
    output logic [2:0] current_floor1, current_floor2,
    output logic [7:0] requests1, requests2,
    output logic [1:0] status1, status2
);

    logic [2:0] max_request1, max_request2;
    logic [2:0] min_request1, min_request2;
    logic door_timer1, door_timer2;
    logic emergency_stopped1, emergency_stopped2;
    logic up1, up2;

    typedef enum logic [1:0] {IDLE = 2'b00, MOVING = 2'b01, DOORS_OPEN = 2'b10} elevator_status_t;

    elevator_status_t lift_status1, lift_status2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            max_request1 <= 0;
            min_request1 <= 7;
            requests1 <= 0;
        end else if (req_floor1 < 8) begin
            requests1[req_floor1] <= 1;
            if (req_floor1 > max_request1) max_request1 <= req_floor1;
            if (req_floor1 < min_request1) min_request1 <= req_floor1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            max_request2 <= 0;
            min_request2 <= 7;
            requests2 <= 0;
        end else if (req_floor2 < 8) begin
            requests2[req_floor2] <= 1;
            if (req_floor2 > max_request2) max_request2 <= req_floor2;
            if (req_floor2 < min_request2) min_request2 <= req_floor2;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_floor1 <= 0;
            door1 <= 0;
            lift_status1 <= IDLE;
            emergency_stopped1 <= 0;
            up1 <= 1;
        end else if (emergency_stop1) begin
            lift_status1 <= IDLE;
            emergency_stopped1 <= 1;
        end else if (emergency_stopped1 && !emergency_stop1) begin
            emergency_stopped1 <= 0;
            lift_status1 <= IDLE;
        end else if (full_capacity1) begin
            lift_status1 <= IDLE;
        end else if (|requests1) begin
            if (requests1[current_floor1]) begin
                door1 <= 1;
                lift_status1 <= DOORS_OPEN;
                requests1[current_floor1] <= 0;
            end else begin
                door1 <= 0;
                lift_status1 <= MOVING;
                if (max_request1 > current_floor1 && up1) begin
                    current_floor1 <= current_floor1 + 1;
                    up1 <= 1;
                end else if (min_request1 < current_floor1) begin
                    current_floor1 <= current_floor1 - 1;
                    up1 <= 0;
                end
            end
        end else lift_status1 <= IDLE;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_floor2 <= 0;
            door2 <= 0;
            lift_status2 <= IDLE;
            emergency_stopped2 <= 0;
            up2 <= 1;
        end else if (emergency_stop2) begin
            lift_status2 <= IDLE;
            emergency_stopped2 <= 1;
        end else if (emergency_stopped2 && !emergency_stop2) begin
            emergency_stopped2 <= 0;
            lift_status2 <= IDLE;
        end else if (full_capacity2) begin
            lift_status2 <= IDLE;
        end else if (|requests2) begin
            if (requests2[current_floor2]) begin
                door2 <= 1;
                lift_status2 <= DOORS_OPEN;
                requests2[current_floor2] <= 0;
            end else begin
                door2 <= 0;
                lift_status2 <= MOVING;
                if (max_request2 > current_floor2 && up2) begin
                    current_floor2 <= current_floor2 + 1;
                    up2 <= 1;
                end else if (min_request2 < current_floor2) begin
                    current_floor2 <= current_floor2 - 1;
                    up2 <= 0;
                end
            end
        end else lift_status2 <= IDLE;
    end

    always_comb begin
        status1 = lift_status1;
        status2 = lift_status2;
    end

endmodule
