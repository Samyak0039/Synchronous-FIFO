`timescale 1ns/1ps

module synchronous_fifo_tb();

    reg clk,reset,wr_en,rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full,empty;

    integer i;
    integer errors;
    integer test_errors;

    reg [7:0] expected_data;

    synchronous_fifo uut(clk,reset,wr_en,rd_en,data_in,data_out,full,empty);

    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial
    begin
        errors = 0;
        test_errors = 0;

        reset = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        @(posedge clk);
        #1 reset = 0;

        wr_en = 1;
        data_in = 8'hA1;

        repeat(3)
        begin
            @(posedge clk);
            #1 data_in = data_in + 1'b1;
        end

        wr_en = 0;
        rd_en = 1;
        expected_data = 8'hA1;
        test_errors = 0;

        repeat(3)
        begin
            @(posedge clk);
            #1;
            if (data_out !== expected_data)
            begin
                $display("FAIL: Expected %h, Got %h",expected_data,data_out);
                test_errors = test_errors + 1;
            end
            expected_data = expected_data + 1'b1;
        end

        rd_en = 0;

        if (empty !== 1'b1 || uut.count !== 0)
            test_errors = test_errors + 1;

        if (test_errors == 0)
            $display("TEST 1 PASSED: Normal write and read");
        else
        begin
            $display("TEST 1 FAILED");
            errors = errors + test_errors;
        end

        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        wr_en = 1;
        data_in = 8'h01;

        repeat(16)
        begin
            @(posedge clk);
            #1 data_in = data_in + 1'b1;
        end

        test_errors = 0;

        if (full !== 1'b1 || uut.count !== 16)
            test_errors = test_errors + 1;

        data_in = 8'hFF;
        @(posedge clk);
        #1;

        if (full !== 1'b1 || uut.count !== 16)
            test_errors = test_errors + 1;

        wr_en = 0;

        if (test_errors == 0)
            $display("TEST 2 PASSED: Full detection and overflow protection");
        else
        begin
            $display("TEST 2 FAILED");
            errors = errors + test_errors;
        end

        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        rd_en = 1;
        @(posedge clk);
        #1;

        test_errors = 0;

        if (empty !== 1'b1 || uut.count !== 0 || data_out !== 8'h00)
            test_errors = test_errors + 1;

        rd_en = 0;

        if (test_errors == 0)
            $display("TEST 3 PASSED: Empty detection and underflow protection");
        else
        begin
            $display("TEST 3 FAILED");
            errors = errors + test_errors;
        end

        wr_en = 1;
        data_in = 8'hA5;

        @(posedge clk);
        #1 data_in = 8'hB6;

        @(posedge clk);
        #1 data_in = 8'hC7;
        rd_en = 1;

        @(posedge clk);
        #1;

        test_errors = 0;

        if (data_out !== 8'hA5 || uut.count !== 2)
            test_errors = test_errors + 1;

        wr_en = 0;

        @(posedge clk);
        #1;

        if (data_out !== 8'hB6 || uut.count !== 1)
            test_errors = test_errors + 1;

        @(posedge clk);
        #1;

        if (data_out !== 8'hC7 || uut.count !== 0 || empty !== 1'b1)
            test_errors = test_errors + 1;

        rd_en = 0;

        if (test_errors == 0)
            $display("TEST 4 PASSED: Simultaneous read and write");
        else
        begin
            $display("TEST 4 FAILED");
            errors = errors + test_errors;
        end

        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        wr_en = 1;
        data_in = 8'h10;

        repeat(16)
        begin
            @(posedge clk);
            #1 data_in = data_in + 1'b1;
        end

        wr_en = 0;
        rd_en = 1;
        expected_data = 8'h10;
        test_errors = 0;

        repeat(16)
        begin
            @(posedge clk);
            #1;

            if (data_out !== expected_data)
                test_errors = test_errors + 1;

            expected_data = expected_data + 1'b1;
        end

        rd_en = 0;

        wr_en = 1;
        data_in = 8'hAA;

        @(posedge clk);
        #1 data_in = 8'hBB;

        @(posedge clk);
        #1 wr_en = 0;

        rd_en = 1;

        @(posedge clk);
        #1;

        if (data_out !== 8'hAA)
            test_errors = test_errors + 1;

        @(posedge clk);
        #1;

        if (data_out !== 8'hBB || empty !== 1'b1)
            test_errors = test_errors + 1;

        rd_en = 0;

        if (test_errors == 0)
            $display("TEST 5 PASSED: Pointer wraparound and address reuse");
        else
        begin
            $display("TEST 5 FAILED");
            errors = errors + test_errors;
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SIMULATION FAILED: Total errors = %0d",errors);

        #10;
        $finish;
    end

endmodule