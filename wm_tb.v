`include "wm.v" // Include the file that contains the washing machine module definition
module washingMachine_tb();
//declaring registetrs for input signals
reg clk,reset,close_door,start,fill,detergent,timeout,drained,spin_timeout;
//declaring wires for input signals
wire door_lock,motor_on,fill_on,drain_on,done,soapWash,waterWash;

//Initiating the washing Machine module
washingMachine dut(clk,reset,close_door,start,fill,detergent,timeout,drained,spin_timeout,door_lock,motor_on,fill_on,drain_on,done,soapWash,waterWash);

initial begin
   $dumpfile("wm.vcd"); // Generate a VCD file for waveform analysis
   $dumpvars(0, washingMachine_tb);

   //Initializing input signals
    clk=0;
    reset=1;
    start=0;
    close_door=0;
    fill=0;
    detergent=0;
    timeout=0;
    drained=0;
    spin_timeout=0;

    #10 reset=0;
    #10 start=1;
    close_door=1;
    #10 fill=1;
    #10 detergent=1;
    #10 timeout=1;
    #10 drained=1;
    #10 spin_timeout=1;
    #10 $finish;
    end

     // Always block to generate the clock signal
    always begin
        #5 clk = ~clk; //Toggle the clock signal every 5 time units
    end
endmodule