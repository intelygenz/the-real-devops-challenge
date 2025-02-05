locals {
   tg_attachments = flatten([
    for tg_key, tg_value in var.target_groups: 
    [
       for instance_id in var.instances_ids : 
      {
        instance_id      = instance_id
        target_group_arn = aws_lb_target_group.this[tg_key].arn
        port             = lookup(tg_value, "port", 80)
        key              = "${tg_key}_${instance_id}"
      }
    ]
  ]) 

/*   tg_attachments = flatten([
       for instance_id in var.instances_ids : 
      {
        instance_id      = instance_id
        target_group_arn = aws_lb_target_group.this["nlb-tg"].arn
        port             = 80
      }
    ]) */
}

