module draw # (
    // vertex_a, vertex_b, vertex_c, mvp_matrix
    parameter WIIA = 8,
    parameter WIFA = 8,
    // width, height
    parameter WIIB = 8,
    parameter WIFB = 0,
    // output V1, V2, V3
    parameter WOI = 10,
    parameter WOF = 8
)
(       input           [3:0][WIIA+WIFA-1:0]    vertex_a, vertex_b, vertex_c,
        input           [15:0][WIIA+WIFA-1:0]   mvp,
        input           [WIIB+WIFB-1:0]         width, height,
        output logic    [1:0][WOI+WOF-1:0]      V1, V2, V3
);

logic [WIIA+WIFA-1:0] x1, y1, w1, x2, y2, w2, x3, y3, w3;
logic [WIIA+WIFA-1:0] x1_normalized, y1_normalized, x2_normalized, y2_normalized, x3_normalized, y3_normalized;

logic [WIIA+WIFA-1:0] x1_add_1, x2_add_1, x3_add_1, y1_add_1, y2_add_1, y3_add_1;
logic [WOI+WOF-1:0] w_mul_x1_add_1, w_mul_x2_add_1, w_mul_x3_add_1, h_mul_y1_add_1, h_mul_y2_add_1, h_mul_y3_add_1;

logic [WIIA+WIFA-1:0] trash0, trash1, trash2;
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic overflow8, overflow9, overflow10, overflow11, overflow12, overflow13, overflow14, overflow15;
logic overflow16, overflow17, overflow18, overflow19, overflow20, overflow21, overflow22, overflow23;

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp00(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(x1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp01(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(y1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp02(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(trash0));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp03(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(w1));

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp10(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(x2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp11(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(y2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp12(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(trash1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp13(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(w2));

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp20(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(x3));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp21(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(y3));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp22(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(trash2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp23(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(w3));

fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div0 (.dividend(x1), .divisor(w1), .out(x1_normalized), .overflow(overflow0));
fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div1 (.dividend(y1), .divisor(w1), .out(y1_normalized), .overflow(overflow1));

fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div2 (.dividend(x2), .divisor(w2), .out(x2_normalized), .overflow(overflow2));
fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div3 (.dividend(y2), .divisor(w2), .out(y2_normalized), .overflow(overflow3));

fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div4 (.dividend(x3), .divisor(w3), .out(x3_normalized), .overflow(overflow4));
fxp_div #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div5 (.dividend(y3), .divisor(w3), .out(y3_normalized), .overflow(overflow5));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add0 (.ina(x1_normalized), .inb(16'h0100), .out(x1_add_1), .overflow(overflow6));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (.ina(width), .inb(x1_add_1), .out(w_mul_x1_add_1), .overflow(overflow7));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div6 (.dividend(w_mul_x1_add_1), .divisor(16'h0200), .out(V1[0]), .overflow(overflow8));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add1 (.ina(y1_normalized), .inb(16'h0100), .out(y1_add_1), .overflow(overflow9));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (.ina(height), .inb(y1_add_1), .out(h_mul_y1_add_1), .overflow(overflow10));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div7 (.dividend(h_mul_y1_add_1), .divisor(16'h0200), .out(V1[1]), .overflow(overflow11));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add2 (.ina(x2_normalized), .inb(16'h0100), .out(x2_add_1), .overflow(overflow12));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul4 (.ina(width), .inb(x2_add_1), .out(w_mul_x2_add_1), .overflow(overflow13));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div8 (.dividend(w_mul_x2_add_1), .divisor(16'h0200), .out(V2[0]), .overflow(overflow14));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add3 (.ina(y2_normalized), .inb(16'h0100), .out(y2_add_1), .overflow(overflow15));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul6 (.ina(height), .inb(y2_add_1), .out(h_mul_y2_add_1), .overflow(overflow16));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div9 (.dividend(h_mul_y2_add_1), .divisor(16'h0200), .out(V2[1]), .overflow(overflow17));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add4 (.ina(x3_normalized), .inb(16'h0100), .out(x3_add_1), .overflow(overflow18));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul8 (.ina(width), .inb(x3_add_1), .out(w_mul_x3_add_1), .overflow(overflow19));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div10 (.dividend(w_mul_x3_add_1), .divisor(16'h0200), .out(V3[0]), .overflow(overflow20));


fxp_add #(   
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add5 (.ina(y3_normalized), .inb(16'h0100), .out(y3_add_1), .overflow(overflow21));
fxp_mul #(   
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul10 (.ina(height), .inb(y3_add_1), .out(h_mul_y3_add_1), .overflow(overflow22));
fxp_div #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div11 (.dividend(h_mul_y3_add_1),.divisor(16'h0200), .out(V3[1]), .overflow(overflow23));

endmodule

module dot_product # (
    parameter WII = 8,
    parameter WIF = 8,
    parameter WOI = 8,
    parameter WOF = 8
)
(   input           [WII+WIF-1:0] a0, a1, a2, a3, b0, b1, b2, b3,
    output logic    [WOI+WOF-1:0] res
);

logic [WOI+WOF-1:0] mul_res0, mul_res1, mul_res2, mul_res3;
logic [WOI+WOF-1:0] add_tmp0, add_tmp1;

logic mul_overflow0, mul_overflow1, mul_overflow2, mul_overflow3;
logic add_overflow0, add_overflow1, add_overflow2;

fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (.ina(a0), .inb(b0), .out(mul_res0), .overflow(overflow0));

fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul1 (.ina(a1), .inb(b1), .out(mul_res1), .overflow(overflow1));

fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (.ina(a2), .inb(b2), .out(mul_res2), .overflow(overflow2));

fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul3 (.ina(a3), .inb(b3), .out(mul_res3), .overflow(overflow3));



fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add0 (.ina(mul_res0), .inb(mul_res1), .out(add_tmp0), .overflow(add_overflow0));

fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add1 (.ina(add_tmp0), .inb(mul_res2), .out(add_tmp1), .overflow(add_overflow1));

fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add2 (.ina(add_tmp1), .inb(mul_res3), .out(res), .overflow(add_overflow2));

endmodule


// Verilog fixed-point number lib: custom bit width, arithmetic, converting to float, with single cycle & pipeline version.
// https://github.com/WangXuan95/Verilog-FixedPoint

module fxp_zoom # (
    parameter WII = 8,
    parameter WIF = 8,
    parameter WOI = 8,
    parameter WOF = 8,
    parameter bit ROUND = 1
)
(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);

logic [WII+WOF-1:0] inr;
logic [WII-1:0] ini;
logic [WOI-1:0] outi;
logic [WOF-1:0] outf;

generate if (WOF<WIF) begin
    if(~ROUND) begin
        assign inr = in[WII+WIF-1:WIF-WOF];
    end else if(WII+WOF>=2) begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & ~(~inr[WII+WOF-1] & (&inr[WII+WOF-2:0]))) inr++;
        end
    end else begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & inr[WII+WOF-1]) inr++;
        end
    end
end else if(WOF==WIF) begin
    assign inr[WII+WOF-1:WOF-WIF] = in;
end else begin
    always @ (*) begin
        inr[WII+WOF-1:WOF-WIF] = in;
        inr[WOF-WIF-1:0] = '0;
    end
end endgenerate

generate if(WOI<WII) begin
    always @ (*) begin
        {ini, outf} = inr;
        overflow = 1'b0;
        outi = ini[WOI-1:0];
        if         ( ~ini[WII-1] & |ini[WII-2:WOI-1] ) begin
            overflow = 1'b1;
            outi[WOI-1] = 1'b0;
            for(int i=0;i<WOI-1;i++) outi[i] = 1'b1;
            outf = '1;
        end else if(  ini[WII-1] & ~(&ini[WII-2:WOI-1]) ) begin
            overflow = 1'b1;
            outi[WOI-1] = 1'b1;
            for(int i=0;i<WOI-1;i++) outi[i] = 1'b0;
            outf = '0;
        end
    end
end else begin
    always @ (*) begin
        {ini, outf} = inr;
        overflow = 1'b0;
        outi[WII-1:0] = ini;
        for(int ii=WII; ii<WOI; ii++) outi[ii] = ini[WII-1];
    end
end endgenerate

assign out = {outi, outf};

endmodule





module fxp_add # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WII = WIIA>WIIB ? WIIA : WIIB;
localparam WIF = WIFA>WIFB ? WIFA : WIFB;
localparam WRI = WII + 1;
localparam WRF = WIF;

wire [WII+WIF-1:0] inaz, inbz;
wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inb      ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





module fxp_addsub # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    input  logic sub, // 0=add, 1=sub
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);
localparam WIIBE = WIIB + 1;
localparam   WII = WIIA>WIIBE ? WIIA : WIIBE;
localparam   WIF = WIFA>WIFB  ? WIFA : WIFB;
localparam   WRI = WII + 1;
localparam   WRF = WIF;

wire [WIIBE+WIFB-1:0] inbe;
wire [WII+WIF-1:0] inaz, inbz;
wire [WIIBE+WIFB-1:0] inbv = sub ? ((~inbe)+1) : inbe;
wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WIIBE    ),
    .WOF      ( WIFB     ),
    .ROUND    ( 0        )
) inb_extend (
    .in       ( inb      ),
    .out      ( inbe     ),
    .overflow (          )
);

// seems to have an error here
// should comment the following line?
//assign inbv = sub ? ((~inbe)+1) : inbe;

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIBE    ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inbv     ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





module fxp_mul # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WRI = WIIA + WIIB;
localparam WRF = WIFA + WIFB;

wire signed [WRI+WRF-1:0] res = $signed(ina) * $signed(inb);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





// --------------------------------------------------------------------------------------------------------
// - NOTE: pipeline stage count = 2
// -       which means out(result) will appear 2 cycles after signals appear on the input
// --------------------------------------------------------------------------------------------------------
module fxp_mul_pipe # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic clk, rst,
    input  logic [WIIA+WIFA-1:0] ina,
    input  logic [WIIB+WIFB-1:0] inb,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);
localparam WRI = WIIA + WIIB;
localparam WRF = WIFA + WIFB;

logic [WOI +WOF -1:0] outc;
logic overflowc;
logic signed [WRI+WRF-1:0] res = '0;

initial {out, overflow} = '0;

always @ (posedge clk or posedge rst)
    if(rst)
        res <= '0;
    else
        res <= $signed(ina) * $signed(inb);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( outc           ),
    .overflow ( overflowc      )
);

always @ (posedge clk or posedge rst)
    if(rst) begin
        out      <= '0;
        overflow <= 1'b0;
    end else begin
        out      <= outc;
        overflow <= overflowc;
    end

endmodule





module fxp_div #(
	parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WIIA+WIFA-1:0] dividend,
    input  logic [WIIB+WIFB-1:0] divisor,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WRI = WOI+WIIB > WIIA ? WOI+WIIB : WIIA;
localparam WRF = WOF+WIFB > WIFA ? WOF+WIFB : WIFA;

logic sign = 1'b0;
logic [WIIA+WIFA-1:0] udividend = '0;
logic [WIIB+WIFB-1:0]  udivisor = '0;
logic [ WRI+ WRF-1:0] acc, acct, divd, divr;

always @ (*) begin  // convert dividend and divisor to positive number
    sign      = dividend[WIIA+WIFA-1] ^ divisor[WIIB+WIFB-1];
    udividend = dividend[WIIA+WIFA-1] ? (~dividend)+1 : dividend;
    udivisor  =  divisor[WIIB+WIFB-1] ? (~ divisor)+1 : divisor ;
end

fxp_zoom # (
    .WII      ( WIIA      ),
    .WIF      ( WIFA      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
) dividend_zoom (
    .in       ( udividend ),
    .out      ( divd      ),
    .overflow (           )
);

fxp_zoom # (
    .WII      ( WIIB      ),
    .WIF      ( WIFB      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
)  divisor_zoom (
    .in       ( udivisor  ),
    .out      ( divr      ),
    .overflow (           )
);

always @ (*) begin
    acc = '0;
    for(int shamt=WOI-1; shamt>=-WOF; shamt--) begin
        if(shamt>=0)
            acct = acc + (divr<<shamt);
        else
            acct = acc + (divr>>(-shamt));
        if( acct <= divd ) begin
            acc = acct;
            out[WOF+shamt] = 1'b1;
        end else
            out[WOF+shamt] = 1'b0;
    end
    
    if(ROUND && ~(&out)) begin
        acct = acc+(divr>>(WOF));
        if(acct-divd<divd-acc)
            out++;
    end
    
    overflow = 1'b0;
    if(sign) begin
        if(out[WOI+WOF-1]) begin
            if(|out[WOI+WOF-2:0]) overflow = 1'b1;
            out[WOI+WOF-1] = 1'b1;
            out[WOI+WOF-2:0] = '0;
        end else begin
            out = (~out)+1;
        end
    end else begin
        if(out[WOI+WOF-1]) begin
            overflow = 1'b1;
            out[WOI+WOF-1] = 1'b0;
            out[WOI+WOF-2:0] = '1;
        end
    end
end

endmodule





// --------------------------------------------------------------------------------------------------------
// - NOTE: pipeline stage count = WOI+WOF+3
// -       which means out(result) will appear (WOI+WOF+3) cycles after signals appear on the input
// --------------------------------------------------------------------------------------------------------
module fxp_div_pipe #(
	parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic clk, rst,
    input  logic [WIIA+WIFA-1:0] dividend,
    input  logic [WIIB+WIFB-1:0] divisor,
    output logic [WOI +WOF -1:0] out,
    output logic overflow
);

localparam WRI = WOI+WIIB > WIIA ? WOI+WIIB : WIIA;
localparam WRF = WOF+WIFB > WIFA ? WOF+WIFB : WIFA;

initial overflow = 1'b0;
initial out = '0;

logic [WOI+WOF-1:0] roundedres='0;
logic rsign = 1'b0;

logic [WRI+WRF-1:0]  divd, divr;
logic sign [WOI+WOF+1];
logic [WRI+WRF-1:0]  acc  [WOI+WOF+1];
logic [WRI+WRF-1:0] divdp [WOI+WOF+1];
logic [WRI+WRF-1:0] divrp [WOI+WOF+1];
logic [WOI+WOF-1:0]  res  [WOI+WOF+1];

// initialize all regs
initial for(int ii=0; ii<=WOI+WOF; ii++) begin
    res  [ii] <= '0;
    divrp[ii] <= '0;
    divdp[ii] <= '0;
    acc  [ii] <= '0;
    sign [ii] <= 1'b0;
end

// convert dividend and divisor to positive number
wire [WIIA+WIFA-1:0] udividend = dividend[WIIA+WIFA-1] ? (~dividend)+1 : dividend;
wire [WIIB+WIFB-1:0]  udivisor =  divisor[WIIB+WIFB-1] ? (~ divisor)+1 : divisor ;

fxp_zoom # (
    .WII      ( WIIA      ),
    .WIF      ( WIFA      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
) dividend_zoom (
    .in       ( udividend ),
    .out      ( divd      ),
    .overflow (           )
);

fxp_zoom # (
    .WII      ( WIIB      ),
    .WIF      ( WIFB      ),
    .WOI      ( WRI       ),
    .WOF      ( WRF       ),
    .ROUND    ( 0         )
)  divisor_zoom (
    .in       ( udivisor  ),
    .out      ( divr      ),
    .overflow (           )
);

// ---------------------------------------------------------------------------------
// 1st pipeline stage: convert dividend and divisor to positive number
// ---------------------------------------------------------------------------------
always @ (posedge clk or posedge rst)
    if(rst) begin
        res[0]   <= '0;
        acc[0]   <= '0;
        divdp[0] <= '0;
        divrp[0] <= '0;
        sign [0] <= 1'b0;
    end else begin
        res[0]   <= '0;
        acc[0]   <= '0;
        divdp[0] <= divd;
        divrp[0] <= divr;
        sign [0] <= dividend[WIIA+WIFA-1] ^ divisor[WIIB+WIFB-1];
    end
    
// ---------------------------------------------------------------------------------
// from 2nd to WOI+WOF+1 pipeline stages: calculate division
// ---------------------------------------------------------------------------------
logic [ WRI+ WRF-1:0] tmp;
always @ (posedge clk or posedge rst)
    if(rst) begin
        for(int ii=0; ii<WOI+WOF; ii++) begin
            res  [ii+1] <= '0;
            divrp[ii+1] <= '0;
            divdp[ii+1] <= '0;
            acc  [ii+1] <= '0;
            sign [ii+1] <= 1'b0;
        end
    end else begin
        for(int ii=0; ii<WOI+WOF; ii++) begin
            res  [ii+1] <= res[ii];
            divdp[ii+1] <= divdp[ii];
            divrp[ii+1] <= divrp[ii];
            sign [ii+1] <= sign [ii];
            if(ii<WOI)
                tmp = acc[ii] + (divrp[ii]<<(WOI-1-ii));
            else
                tmp = acc[ii] + (divrp[ii]>>(1+ii-WOI));
            if( tmp < divdp[ii] ) begin
                acc[ii+1] <= tmp;
                res[ii+1][WOF+WOI-1-ii] <= 1'b1;
            end else begin
                acc[ii+1] <= acc[ii];
                res[ii+1][WOF+WOI-1-ii] <= 1'b0;
            end
        end
    end


// ---------------------------------------------------------------------------------
// next pipeline stage: process round
// ---------------------------------------------------------------------------------
always @ (posedge clk or posedge rst)
    if(rst) begin
        roundedres <= '0;
        rsign      <= 1'b0;
    end else begin
        if( ROUND && ~(&res[WOI+WOF]) && (acc[WOI+WOF]+(divrp[WOI+WOF]>>(WOF))-divdp[WOI+WOF]) < (divdp[WOI+WOF]-acc[WOI+WOF]) )
            roundedres <= res[WOI+WOF] + 1;
        else
            roundedres <= res[WOI+WOF];
        rsign      <= sign[WOI+WOF];
    end


// ---------------------------------------------------------------------------------
// the last pipeline stage: process roof and output
// ---------------------------------------------------------------------------------
always @ (posedge clk or posedge rst)
    if(rst) begin
        overflow = 1'b0;
        out = '0;
    end else begin
        overflow = 1'b0;
        out = roundedres;
        if(rsign) begin
            if(out[WOI+WOF-1]) begin
                if(|out[WOI+WOF-2:0]) overflow = 1'b1;
                out[WOI+WOF-1] = 1'b1;
                out[WOI+WOF-2:0] = '0;
            end else
                out = (~out)+1;
        end else begin
            if(out[WOI+WOF-1]) begin
                overflow = 1'b1;
                out[WOI+WOF-1] = 1'b0;
                out[WOI+WOF-2:0] = '1;
            end
        end
    end

endmodule





module fxp_sqrt #(
    parameter WII  = 8,
    parameter WIF  = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);

localparam WTI = (WII%2==1) ? WII+1 : WII;
localparam WRI = WTI/2;

wire  sign = in[WII+WIF-1];
logic [WTI+WIF-1:0] inu;
logic [WTI+WIF-1:0] resu2, resu2tmp;
logic [WTI+WIF-1:0] resu;
wire  [WRI+WIF  :0] resushort = sign ? (~resu[WRI+WIF:0])+1 : resu[WRI+WIF:0];
always @ (*) begin
    inu = '0;
    inu[WII+WIF-1:0] = sign ? (~in)+1 : in;
end

always @ (*) begin
    {resu2,resu} = '0;
    for(int ii=WRI-1; ii>=-WIF; ii--) begin
        resu2tmp = resu2;
        if(ii>=0) resu2tmp += (resu<<( 1+ii));
        else      resu2tmp += (resu>>(-1-ii));
        if(2*ii+WIF>=0) resu2tmp += (1<<(2*ii+WIF));
        if(resu2tmp<=inu && inu!=0) begin
            resu[ii+WIF] = 1'b1;
            resu2 = resu2tmp;
        end
    end
end

fxp_zoom # (
    .WII      ( WRI+1          ),
    .WIF      ( WIF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( resushort      ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule





// --------------------------------------------------------------------------------------------------------
// - NOTE: pipeline stage count = [WII/2] + WIF + 2, [] means upper int
// -       which means out(result) will appear ([WII/2]+WIF+2) cycles after signals appear on the input
// --------------------------------------------------------------------------------------------------------
module fxp_sqrt_pipe #(
    parameter WII  = 8,
    parameter WIF  = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic clk, rst,
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);

localparam WTI = (WII%2==1) ? WII+1 : WII;
localparam WRI = WTI/2;

int jj;
logic sign [WRI+WIF+1];
logic [WTI+WIF-1:0] inu  [WRI+WIF+1];
logic [WTI+WIF-1:0] resu2tmp;
logic [WTI+WIF-1:0] resu2 [WRI+WIF+1];
logic [WTI+WIF-1:0] resu  [WRI+WIF+1];

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        for(int ii=0; ii<=WRI+WIF; ii++) begin
            sign[ii] <= '0;
            inu[ii] <= '0;
            resu2[ii] <= '0;
            resu[ii] <= '0;
        end
    end else begin
        sign[0] <= in[WII+WIF-1];
        inu[0] <= '0;
        inu[0][WII+WIF-1:0] <= in[WII+WIF-1] ? (~in)+1 : in;
        resu2[0] <= '0;
        resu[0] <= '0;
        for(int ii=WRI-1; ii>=-WIF; ii--) begin
            jj = WRI-1-ii;
            sign[jj+1] <= sign[jj];
            inu [jj+1] <= inu [jj];
            resu[jj+1] <= resu[jj];
            resu2[jj+1]<= resu2[jj];
            resu2tmp = resu2[jj];
            if(ii>=0) resu2tmp += (resu[jj]<<( 1+ii));
            else      resu2tmp += (resu[jj]>>(-1-ii));
            if(2*ii+WIF>=0) resu2tmp += (1<<(2*ii+WIF));
            if(resu2tmp<=inu[jj] && inu[jj]!=0) begin
                resu[jj+1][ii+WIF] <= 1'b1;
                resu2[jj+1] <= resu2tmp;
            end
        end
    end
end

wire  [WRI+WIF  :0] resushort = sign[WRI+WIF] ? (~resu[WRI+WIF][WRI+WIF:0])+1 : resu[WRI+WIF][WRI+WIF:0];
logic [WOI+WOF-1:0] outl;
logic overflowl;

fxp_zoom # (
    .WII      ( WRI+1          ),
    .WIF      ( WIF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( resushort      ),
    .out      ( outl           ),
    .overflow ( overflowl      )
);

always @ (posedge clk or posedge rst)
    if(rst)
        {overflow,out} = '0;
    else
        {overflow,out} = {overflowl,outl};

endmodule





module fxp_sin #(   // use Cordic Algorithm
    parameter WII  = 4,
    parameter WIF  = 8,
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic i_overflow
);

localparam N_ITER = 8;
localparam WRI = 4;
localparam WRF = WOF>WIF ? WOF : WIF;
logic [WRI+WRF-1:0] xinit, target, halfpi, x, y, z, xt;
wire  [WRI+WRF-1:0] atan_table [N_ITER];
logic  overflowc, overflowl;

assign i_overflow = overflowc | overflowl;

fxp_zoom # (WRI,WRF,WOI,WOF,ROUND) out_zoom ( y, out   , overflowc );
fxp_zoom # (WII,WIF,WRI,WRF,    1)  in_zoom (in, target,           );

fxp_zoom # (4,28,WRI,WRF,1)    pi_zoom (32'h1921fb54, halfpi      ,);
fxp_zoom # (4,28,WRI,WRF,1) xinit_zoom (32'h09b75555, xinit       ,);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom0 (32'h0c90fdaa,atan_table[0],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom1 (32'h076b19c1,atan_table[1],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom2 (32'h03eb6ebf,atan_table[2],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom3 (32'h01fd5ba9,atan_table[3],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom4 (32'h00ffaadd,atan_table[4],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom5 (32'h007ff556,atan_table[5],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom6 (32'h003ffeaa,atan_table[6],);
fxp_zoom # (4,28,WRI,WRF,1) atan_zoom7 (32'h001fffd5,atan_table[7],);

always @ (*) begin
    y = '0;
    overflowl = 1'b0;
    if( target[WRI+WRF-1] )
        overflowl = 1'b1;
    else if( target>halfpi ) begin
        overflowl = 1'b1;
        y[WRF] = 1'b1;
    end else begin
        x = xinit;
        z = '0;
        for(int ii=0; ii<N_ITER; ii++) begin
            xt = (x>>ii);
            if(target > z) begin
                x -= (y>>ii);
                y += xt;
                z += atan_table[ii];
            end else begin
                x += (y>>ii);
                y -= xt;
                z -= atan_table[ii];
            end
        end
    end
end

endmodule





module fxp2float #(
    parameter WII = 8,
    parameter WIF = 8
)(
    input  logic [WII+WIF-1:0] in,
    output logic [31:0] out
);

logic flag;
logic signed [9:0] expz, ii, jj;
logic [ 7:0] expt;
logic [22:0] tail;
wire  sign = in[WII+WIF-1];
wire  [WII+WIF-1:0] inu = sign ? (~in)+1 : in;

always @ (*) begin
    tail = '0;
    flag = 1'b0;
    ii = 22;
    expz = '0;
    for(jj=WII+WIF-1; jj>=0; jj--) begin
        if(flag && ii>=0)
            tail[ii--] = inu[jj];
        if(inu[jj]) begin
            if(~flag) expz = jj - WIF + 127;
            flag = 1'b1;
        end
    end

    if(expz<$signed(10'd255))
        expt = (inu==0) ? '0 : expz[7:0];
    else begin
        expt = 8'd254;
        tail = '1;
    end
end

assign out = {sign, expt, tail};

endmodule





// --------------------------------------------------------------------------------------------------------
// - NOTE: pipeline stage count = WII + WIF + 2
// -       which means out(result) will appear (WII+WIF+2) cycles after signals appear on the input
// --------------------------------------------------------------------------------------------------------
module fxp2float_pipe #(
    parameter WII = 8,
    parameter WIF = 8
)(
    input  logic clk, rst,
    input  logic [WII+WIF-1:0] in,
    output logic [31:0] out
);

logic              sign [WII+WIF+1];
logic        [9:0] exp  [WII+WIF+1];
logic [WII+WIF-1:0] inu [WII+WIF+1];

logic [23:0] vall;
logic [23:0] valo;
logic [ 7:0] expo;
logic signo;

assign out = {signo, expo, valo[22:0]};

initial
    for(int ii=WII+WIF; ii>=0; ii--) begin
        sign[ii] = '0;
        exp[ii]  = '0;
        inu[ii]  = '0;
    end

always @ (posedge clk or posedge rst)
    if(rst) begin
        for(int ii=WII+WIF; ii>=0; ii--) begin
            sign[ii] <= '0;
            exp[ii]  <= '0;
            inu[ii]  <= '0;
        end
    end else begin
        sign[WII+WIF] <= in[WII+WIF-1];
        exp [WII+WIF] <= WII+127-1;
        inu[WII+WIF]  <= in[WII+WIF-1] ? (~in)+1 : in;
        for(int ii=WII+WIF-1; ii>=0; ii--) begin
            sign[ii] <= sign[ii+1];
            if(inu[ii+1][WII+WIF-1]) begin
                exp[ii] <= exp[ii+1];
                inu[ii] <= inu[ii+1];
            end else begin
                if(exp[ii+1]!=0)
                    exp[ii] <= exp[ii+1] - 1;
                else
                    exp[ii] <= exp[ii+1];
                inu[ii] <=(inu[ii+1] << 1);
            end
        end
    end
    
generate if(23>WII+WIF-1) begin
    always @ (*) begin
        vall = '0;
        vall[23:23-(WII+WIF-1)] = inu[0];
    end
end else begin
    assign vall = inu[0][WII+WIF-1:WII+WIF-1-23];
end endgenerate

initial {signo, expo, valo} = '0;

always @ (posedge clk or posedge rst)
    if(rst) begin
        {signo, expo, valo} = '0;
    end else begin
        signo = sign[0];
        if(exp[0]>=10'd255) begin
            expo = 8'd255;
            valo = '1;
        end else if(exp[0]==10'd0 || ~vall[23]) begin
            expo = 8'd0;
            valo = '0;
        end else begin
            expo = exp[0][7:0];
            valo = vall;
        end
    end
    
endmodule





module float2fxp #(
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic [31:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);

logic round, sign;
logic [ 7:0] exp;
int expi;
logic [23:0] val;

always @ (*) begin
    {round, overflow} = '0;
    {sign, exp, val[22:0]} = in;
    val[23] = 1'b1;
    out = '0;
    if( &exp )
        overflow = 1'b1;
    else if( in[30:0]!=0 ) begin
        expi = exp-127+WOF;
        for(int ii=23; ii>=0; ii--) begin
            if(val[ii]) begin
                if(expi>=WOI+WOF-1)
                    overflow = 1'b1;
                else if(expi>=0)
                    out[expi] = 1'b1;
                else if(ROUND && expi==-1)
                    round=1;
            end
            expi--;
        end
        if(round) out++;
    end
    if(overflow) begin
        if(sign) begin
            out[WOI+WOF-1]   = 1'b1;
            out[WOI+WOF-2:0] = '0;
        end else begin
            out[WOI+WOF-1]   = 1'b0;
            out[WOI+WOF-2:0] = '1;
        end
    end else begin
        if(sign)
            out = (~out) + 1;
    end
end

endmodule





// --------------------------------------------------------------------------------------------------------
// - NOTE: pipeline stage count = WOI + WOF + 3
// -       which means out(result) will appear (WOI+WOF+3) cycles after signals appear on the input
// --------------------------------------------------------------------------------------------------------
module float2fxp_pipe #(
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter bit ROUND= 1
)(
    input  logic clk, rst,
    input  logic [31:0] in,
    output logic [WOI+WOF-1:0] out,
    output logic overflow
);
// ------------------------------------------------------------------------------------
// input comb logic
// ------------------------------------------------------------------------------------
logic sign;
logic [ 7:0] exp;
logic [23:0] val;

assign {sign,exp,val[22:0]} = in;
assign val[23] = |exp;

// ------------------------------------------------------------------------------------
// pipeline stage1
// ------------------------------------------------------------------------------------
logic signinit=1'b0, roundinit=1'b0;
logic signed [31:0] expinit = '0;
logic [WOI+WOF-1:0] outinit = '0;

generate if(WOI+WOF-1>=23) begin
    always @ (posedge clk or posedge rst)
        if(rst) begin
            outinit = '0;
            roundinit = 1'b0;
        end else begin
            outinit = '0;
            outinit[WOI+WOF-1:WOI+WOF-1-23] = val;
            roundinit = 1'b0;
        end
end else begin
    always @ (posedge clk or posedge rst)
        if(rst) begin
            outinit = '0;
            roundinit = 1'b0;
        end else begin
            outinit = val[23:23-(WOI+WOF-1)];
            roundinit = ( ROUND && val[23-(WOI+WOF-1)-1] );
        end
end endgenerate

always @ (posedge clk or posedge rst)
    if(rst) begin
        signinit = 1'b0;
        expinit  = 0;
    end else begin
        signinit = sign;
        expinit  = exp - (WOI-1) - 127;
        if(exp==8'd255 || expinit>0 )
            expinit = 0;
    end
        
// ------------------------------------------------------------------------------------
// next pipeline stages
// ------------------------------------------------------------------------------------
logic signs [WOI+WOF+1];
logic rounds[WOI+WOF+1];
logic [31:0] exps[WOI+WOF+1];
logic [WOI+WOF-1:0] outs[WOI+WOF+1];

always @ (posedge clk or posedge rst)
    if(rst) begin
        for(int ii=0; ii<WOI+WOF+1; ii++) begin
            signs[ii]  = '0;
            rounds[ii] = '0;
            exps[ii]   = '0;
            outs[ii]   = '0;
        end
    end else begin
        signs[WOI+WOF] = signinit;
        rounds[WOI+WOF] = roundinit;
        exps[WOI+WOF] = expinit;
        outs[WOI+WOF] = outinit;
        for(int ii=0; ii<WOI+WOF; ii++) begin
            signs[ii] = signs[ii+1];
            if(exps[ii+1]!=0) begin
                {outs[ii], rounds[ii]} = {       1'b0,   outs[ii+1] };
                exps[ii] = exps[ii+1] + 1;
            end else begin
                {outs[ii], rounds[ii]} = { outs[ii+1], rounds[ii+1] };
                exps[ii] = exps[ii+1];
            end
        end
    end
    
// ------------------------------------------------------------------------------------
// last 2nd pipeline stage
// ------------------------------------------------------------------------------------
logic signl = 1'b0;
logic [WOI+WOF-1:0] outl = '0;
always @ (posedge clk or posedge rst)
    if(rst) begin
        outl = '0;
        signl = 1'b0;
    end else begin
        outl = outs[0];
        if(ROUND & rounds[0] & ~(&outl))
            outl++;
        if(signs[0]) begin
            signl = (outl!=0);
            outl  = (~outl) + 1;
        end else
            signl = 1'b0;
    end

// ------------------------------------------------------------------------------------
// last 1st pipeline stage: overflow control
// ------------------------------------------------------------------------------------
initial out = '0;
initial overflow = 1'b0;
always @ (posedge clk)
    if(rst) begin
        out = '0;
        overflow = 1'b0;
    end else begin
        out = outl;
        overflow = 1'b0;
        if(signl) begin
            if(~outl[WOI+WOF-1]) begin
                out[WOI+WOF-1] = 1'b1;
                out[WOI+WOF-2:0] = '0;
                overflow = 1'b1;
            end
        end else begin
            if(outl[WOI+WOF-1]) begin
                out[WOI+WOF-1] = 1'b0;
                out[WOI+WOF-2:0] = '1;
                overflow = 1'b1;
            end
        end
    end

endmodule
