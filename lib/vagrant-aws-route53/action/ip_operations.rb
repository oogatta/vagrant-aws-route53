require 'aws-sdk-v1'

module VagrantPlugins
  module AwsRoute53
    module Action
      class IpOperations
        private
        def config(environment)
          config          = environment[:machine].config
          provider_config = environment[:machine].provider_config

          access_key_id     = provider_config.access_key_id
          secret_access_key = provider_config.secret_access_key
          region            = provider_config.region
          instance_id       = environment[:machine].id
          hosted_zone_id    = config.route53.hosted_zone_id
          record_set        = config.route53.record_set

          return access_key_id, hosted_zone_id, instance_id, record_set, region, secret_access_key
        end

        def set(options)
          ::AWS.config(access_key_id: options[:access_key_id], secret_access_key: options[:secret_access_key], region: options[:region])

          ec2 = ::AWS.ec2
          public_ip = options[:public_ip] || ec2.instances[options[:instance_id]].public_ip_address
          public_dns_name = ec2.instances[options[:instance_id]].public_dns_name

          record_sets = ::AWS::Route53::HostedZone.new(options[:hosted_zone_id]).rrsets
          record_set  = record_sets[*options[:record_set]]
          if options[:record_set][0] == 'CNAME'
            value_for_logs = public_dns_name
            record_set.resource_records = [{value: public_dns_name}]
          else
            value_for_logs = public_ip
            record_set.resource_records = [{value: public_ip}]
          end
          record_set.update

          if block_given?
            yield options[:instance_id], value_for_logs, options[:record_set]
          end

          nil
        end
      end
    end
  end
end
