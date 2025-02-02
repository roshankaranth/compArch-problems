`timescale 1ns/1ps 
//defines the unit of time used in simulation i.e 1ns and precision of time measurment which is 1ps
module nand_gate(c,a,b); //module declaration, with 3 ports
    output c; //this value is accessible outside the module
    input a,b; //a,b recieve signal from outside the module
    wire d; //internal signal

    and a1(d,a,b); //instantiates and gate named a1
    not n1(c,d);
endmodule

module testbench; //special module, has no inputs and outputs. Only used for simulation.
    // Declare signals for inputs and output
    reg a, b;       // Inputs to the NAND gate
    //reg is used for signals that are assigned values withing procedural blocks (initial, always)
    wire c;         // Output from the NAND gate
    //wire is used for signals that are driven by continuous assignment or module outputs

    // Instantiate the nand_gate module
    nand_gate nand_instance (.c(c), .a(a), .b(b)); //connecting signals using named port connection
    //alternatively, nand_gate nand_instance(c,a,b);
    initial begin
        $monitor("Time = %0t: a = %b, b = %b, c = %b", $time,a,b,c);
        //monitor monitors specified signals and prints a message whenever any one of them changes
    end

    // Test procedure. runs once at the start of simulation
    initial begin
        // Test different input combinations
        a = 0; b = 0; #10; // c should be 1
        //assigns a and b values. and # represcents delay for 10 seconds before computing c.
        a = 0; b = 1; #10; // c should be 1
        a = 1; b = 0; #10; // c should be 1
        a = 1; b = 1; #10; // c should be 0
        $finish; // End the simulation
    end
endmodule

// input : declares ports through which signals are recieved by module
// output : declares ports throgh which module sends signals outside

// reg: storage elements always used inside always or initial blocks where signals need
//to store values.
//wire: connections module instances, continuous assignment. 

//continuous assignment : is where the value on the left is updated whenever the value on the right hand side changes
//they do not retain values