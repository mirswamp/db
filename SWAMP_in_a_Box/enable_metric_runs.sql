# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2018 Software Assurance Marketplace

SET GLOBAL event_scheduler = ON;
use metric;
drop EVENT if exists initiate_metric_runs;
CREATE EVENT initiate_metric_runs
  ON SCHEDULE EVERY 1 MINUTE
  DO CALL metric.initiate_metric_runs();
