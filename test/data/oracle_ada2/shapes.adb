--  ============================================================================
--
--         WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.
--
--  This file was generated from Shapes.idl
--  using RTI Code Generator (rtiddsgen) version 4.7.0.
--  The rtiddsgen tool is part of the RTI Connext DDS distribution.
--  For more information, type 'rtiddsgen -help' at a command shell
--  or consult the Code Generator User's Manual.
--
--  ============================================================================

pragma Extensions_Allowed (On);
pragma Style_Checks (off);

with RTI;

package body Shapes is


   use type Standard.RTI.Bool;
   procedure Initialize
     (This              : in out Color) is
      function Internal
        (This : not null access Color)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Color_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Color) is
      procedure Internal
        (This : access Color;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "Shapes_Color_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Color;
      Src : in Color) is
      function Internal
        (Dst : not null access Color;
         Src : not null access Color)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Color_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out Point) is
      function Internal
        (This : not null access Point)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Point_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Point) is
      procedure Internal
        (This : access Point;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "Shapes_Point_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Point;
      Src : in Point) is
      function Internal
        (Dst : not null access Point;
         Src : not null access Point)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Point_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
   procedure Initialize
     (This              : in out Polygon) is
      function Internal
        (This : not null access Polygon)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Polygon_initialize");
   begin
      if not Internal (This'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to initialize";
      end if;
   end Initialize;

   procedure Finalize
     (This            : in out Polygon) is
      procedure Internal
        (This : access Polygon;
         deletePointers : Standard.RTI.Bool);
      pragma Import (C, Internal, "Shapes_Polygon_finalize_ex");
   begin
      Internal (This'Unrestricted_Access, Standard.RTI.RTI_BOOL_TRUE);
   end Finalize;

   procedure Copy
     (Dst : in out Polygon;
      Src : in Polygon) is
      function Internal
        (Dst : not null access Polygon;
         Src : not null access Polygon)
         return Standard.RTI.Bool;
      pragma Import (C, Internal, "Shapes_Polygon_copy");
   begin
      if not Internal (Dst'Unrestricted_Access, Src'Unrestricted_Access) then
         raise Standard.DDS.ERROR with "unable to copy";
      end if;
   end Copy;
 end Shapes;

