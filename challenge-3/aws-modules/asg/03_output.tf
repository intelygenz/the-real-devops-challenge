output asg_instances_ids {
  value       = data.aws_instances.asg_instances.ids
  description = "The instances ids of the asg"
  depends_on  = [aws_autoscaling_group.this,
  aws_launch_template.this]
}
