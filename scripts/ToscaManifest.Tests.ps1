
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

Describe -Tags "ToscaManifest" "ToscaManifest" {

	Mock Export-ModuleMember { return $null; }
	
	. "$here\$sut"
	
	Context "ToscaManifest" {
	
		# Context wide constants
		# N/A
		
		# Arrange
		$xml = Invoke-RestMethod https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/TOSCA-Metadata/TOSCA.meta;
		
		It "ToscaManifest-InterfaceLifecycleIsAvailable" -Test {			
			# Arrange
						
			# Act
			$if = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle';
			
			# Act and Assert
			$if | Should not be $null;
		}

		It "ToscaManifest-NodeTemplateReferNodeType" -Test {
			# Arrange
			
			# Act
			$type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
			
			# Assert
			$xml.Definitions.NodeType.type | Should be $type
		}
		
		It "ToscaManifest-NodeTypeContainsInterfaces" -Test {
			# Arrange
			
			# Act
			$NodeType = $xml.Definitions.NodeType
			
			# Act & Assert
			foreach ($NodeTypeName in $NodeType.type) {
				$result = $xml.Definitions.NodeType |? type -eq $NodeTypeName;
				$result.Interfaces.Interface | should not be $null;
			}
			
		}
		
		It "ToscaManifest-NodeTypeReferNodeTypeImplementation" -Test {
			# Arrange
			
			# Act
			$name = $xml.Definitions.NodeType.type.split(":");
			
			# Assert
			$name[1] | Should be $xml.Definitions.NodeTypeImplementation.name;
		}
		
		# It "ToscaManifest-ArtifactWithLifecycleLinkAvailable" -Test {
			# # Arrange
			# biz.dfch.Appclusive.Interfaces.Lifecycle.json
			# # Act
			# 
			
			# # Assert
			# 
		# }
		
		It "ToscaManifest-AllLifecycleInterfaceOperationReferToImplementationArtifact" -Test {			
			# Arrange
						
			# Act
			$if = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle'
			
			# Act and Assert
			foreach ($operation in $if.Operation.name) {
				$result = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq $operation;
				$result.operationName | should be $operation;
			}
		}
		
		It "ToscaManifest-AllImplementationArtifactsReferToArtifactReference" -Test {			
			# Arrange
						
			# Act
			$if = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact
			
			# Act and Assert
			foreach ($artifactRef in $if.artifactRef) {
				$result = $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq $artifactRef;
				$result.id | should be $artifactRef;
			}
		}

		It "ToscaManifest-AllDeploymentArtifactssReferToArtifactReference" -Test {			
			# Arrange
						
			# Act
			$if = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.DeploymentArtifacts
			
			# Act and Assert
			foreach ($artifactRef in $if.artifactRef) {
				$result = $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq $artifactRef;
				$result.id | should be $artifactRef;
			}
		}
		
		# It "ToscaManifest-" -Test {		
			# # Arrange
			
			# https://gitlab.msp.sharedop.net/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnCreated.bpmn20.xml
			
			# # Act
			# $type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
			
			# # Act and Assert
			# $xml.Definitions.NodeType.type | Should be $type
			
			# foreach ($operation in $if.Operation.name) {
				# $result = $xml.Definitions.ArtifactReferences.ArtifactReference.Id |? operationName -eq $operation;
				# $result.operationName | should be $operation
				# 1 | Should be 1;
				
				# $fsm = Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json'
				# $fsm.GetType()
			# }
		
			# # $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq 'cd116073-97b7-45d0-879d-5177de92158d'
			# # ($xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq 'cd116073-97b7-45d0-879d-5177de92158d').reference
			# Invoke-RestMethod 'https://gitlab.msp.sharedop.net/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnStarted.bpmn20.xml'
			# Invoke-RestMethod 'https://github.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnStarted.bpmn20.xml'
			# Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/scripts/OnDecommissioning.bpmn20.xml'
			# Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json'
			# Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json' | ConvertFrom-Json
			# # $fsm = Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json'
			# # $fsm.GetType()
		# }		
	}
}