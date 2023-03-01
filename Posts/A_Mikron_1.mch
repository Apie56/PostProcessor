{
   "controller" : {
      "default" : {
         "max_block_processing_speed" : 50400,
         "max_normal_speed" : 72000,
         "parts" : {
            "head" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_0" : {
               "max_normal_speed" : 72000,
               "max_rapid_speed" : 15000,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_1" : {
               "max_normal_speed" : 72000,
               "max_rapid_speed" : 12000,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_2" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "rotary_0" : {
               "coordinate" : 2,
               "max_normal_speed" : 72000,
               "max_rapid_speed" : 15000,
               "preference" : "no preference",
               "reset" : "before every operation",
               "reversed" : false,
               "tcp" : true,
               "zero_position_offset" : 0
            },
            "table" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            }
         }
      }
   },
   "general" : {
      "capabilities" : [ "cutting", "milling" ],
      "description" : "Tangential Rotary Blade Cutting Machine",
      "minimumRevision" : 45805,
      "model" : "Mikron 1",
      "vendor" : "Aeronaut"
   },
   "kinematics" : {
      "default" : {
         "conventions" : {
            "rotation" : "right-handed"
         },
         "parts" : [
            {
               "control" : "driven",
               "direction" : [ -1, 0, 0 ],
               "id" : "linear_0",
               "max" : 1800,
               "min" : 0,
               "name" : "X",
               "parts" : [
                  {
                     "control" : "driven",
                     "direction" : [ 0, -1, 0 ],
                     "id" : "linear_1",
                     "max" : 2500,
                     "min" : 0,
                     "name" : "Y",
                     "parts" : [
                        {
                           "control" : "driven",
                           "direction" : [ 0, 0, -1 ],
                           "id" : "linear_2",
                           "name" : "Z",
                           "parts" : [
                              {
                                 "axis_of_rotation" : {
                                    "direction" : [ -0, -0, -1 ],
                                    "point" : [ 0, 0, 0 ]
                                 },
                                 "control" : "driven",
                                 "id" : "rotary_0",
                                 "name" : "A",
                                 "parts" : [
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "display_name" : "table",
                                       "id" : "table",
                                       "type" : "table"
                                    }
                                 ],
                                 "type" : "rotary"
                              }
                           ],
                           "type" : "linear"
                        }
                     ],
                     "type" : "linear"
                  }
               ],
               "type" : "linear"
            },
            {
               "attach_frame" : {
                  "point" : [ 0, 0, 0 ],
                  "x_direction" : [ 1, 0, 0 ],
                  "z_direction" : [ 0, 0, 1 ]
               },
               "display_name" : "head",
               "id" : "head",
               "spindle" : {
                  "max_speed" : 0,
                  "min_speed" : 0
               },
               "tool_station" : {
                  "coolants" : null,
                  "max_tool_diameter" : 0,
                  "max_tool_length" : 0
               },
               "type" : "head"
            }
         ],
         "units" : {
            "angle" : "degrees",
            "length" : "mm"
         }
      }
   },
   "machining" : {
      "default" : {
         "feedrate_ratio" : 1,
         "tool_change_time" : 15
      }
   },
   "multiaxis" : {
      "default" : {
         "feedrate" : {
            "BPW_ratio" : 1,
            "max_feedrate" : 9999.9899999999998,
            "method" : "FPM",
            "output_tolerance" : 0.5,
            "type" : "combination"
         },
         "retract_and_reconfigure" : {
            "enabled" : false,
            "safe_plunge_feedrate" : 250,
            "safe_retract_distance" : 25,
            "safe_retract_feedrate" : 500,
            "stock_expansion" : [ 2.5, 2.5, 2.5 ]
         },
         "singularity" : {
            "adjust" : true,
            "angle" : 0.17453292519943295,
            "cone" : 0.05235987755982989,
            "method" : "off",
            "tolerance" : 0.040000000000000001
         },
         "virtual_tool_tip" : false
      }
   },
   "post" : {
      "default" : {
         "output_folder" : "C:\\Users\\anton\\OneDrive - Stellenbosch University\\Documents\\Vac Work\\Advanced Fibreform\\Posts",
         "path" : "user://tangential-blade.cps"
      }
   },
   "tooling" : {
      "default" : {
         "has_tool_changer" : false,
         "number_of_tools" : 1,
         "supports_tool_preload" : false
      }
   }
}

