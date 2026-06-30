#!/usr/bin/env bash
lvextend -L +"$EXTEND_BY" "/dev/$VG_NAME/$LV_NAME"
resize2fs "/dev/$VG_NAME/$LV_NAME"
