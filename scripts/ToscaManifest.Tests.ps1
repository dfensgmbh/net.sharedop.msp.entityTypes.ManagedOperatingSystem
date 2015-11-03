
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

Describe -Tags "Test-ToscaManifest" "Test-ToscaManifest" {

	Mock Export-ModuleMember { return $null; }
	
	. "$here\$sut"
	
	Context "Test-ToscaManifest" {
	
		# Context wide constants
		$RepositoryUrl = 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/';
		$BranchName = 'master';

		New-Variable baseUri;
		$manifestUri;
		
		$Manifest = 'TOSCA-Metadata/TOSCA.meta';

		$ToscaInterfaceLifecycle = 'biz.dfch.Appclusive.Interfaces.Lifecycle';
		
		It "Warmup" -Test {			
			$explanation = 'This test only exists to mitigate the timing error on the first displayed test result.';
		}

		It "Manifest-IsValidBaseUri" -Test {
			# Arrange
			
			# Act
			$result = [Uri]::TryCreate([uri] $RepositoryUrl, [uri] $BranchName, [ref] $baseUri);
			
			# Assert
			$result | Should Be $true;
			$baseUri.IsAbsoluteUri | Should Be $true;
		}
		
		It "Manifest-IsValidManifestUri" -Test {
			# Arrange

			# Act
			[uri] $manifestUri = '{0}/{1}' -f $baseUri.AbsoluteUri, $Manifest;
			
			# Assert
			$manifestUri.IsAbsoluteUri | Should Be $true;
			
		}
		
		It "Manifest-IsAvailable" -Test {
			# Arrange

			# Act
			$xml = Invoke-RestMethod $manifestUri;
			
			# Assert
			$xml | Should Not Be $null;
		}

		It "Manifest-IsValidXmlDocument" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml -is [System.Xml.XmlDocument] | Should Be $true
		}

		It "Manifest-HasDefintionsElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions | Should Not Be $null;
		}

		It "Manifest-HasNodeTypeElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions.NodeType | Should Not Be $null;
		}

		It "Manifest-HasServiceTemplateElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions.ServiceTemplate | Should Not Be $null;
		}

		It "Manifest-HasNodeTypeImplementationElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions.NodeTypeImplementation | Should Not Be $null;
		}

		It "Manifest-HasArtifactReferencesElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions.ArtifactReferences | Should Not Be $null;
		}

		It "Manifest-HasImportElement" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml.Definitions.Import | Should Not Be $null;
		}

		It "Manifest-HasLifecycleInterface" -Test {			
			# Arrange

			# Act
			$if = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq $ToscaInterfaceLifecycle;
			
			# Assert
			$if | Should Not Be $null;
		}

		It "Manifest-NodeTemplateRefersToNodeType" -Test {
			# Arrange
			
			# Act
			$type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
			
			# Assert
			$xml.Definitions.NodeType.type | Should Be $type
		}
		
		It "Manifest-NodeTypeContainsInterfaces" -Test {
			# Arrange
			
			# Act
			$NodeType = $xml.Definitions.NodeType
			
			# Act and Assert
			foreach ($NodeTypeName in $NodeType.type) {
				$result = $xml.Definitions.NodeType |? type -eq $NodeTypeName;
				$result.Interfaces.Interface | Should Not Be $null;
			}
			
		}
		
		It "Manifest-NodeTypeRefersToNodeTypeImplementation" -Test {
			# Arrange
			
			# Act
			$name = $xml.Definitions.NodeType.type.split(":");
			
			# Assert
			$name[1] | Should Be $xml.Definitions.NodeTypeImplementation.name;
		}
		
		# It "Manifest-ArtifactWithLifecycleLinkAvailable" -Test {
			# # Arrange
			# biz.dfch.Appclusive.Interfaces.Lifecycle.json
			# # Act
			# 
			
			# # Assert
			# 
		# }
		
		It "Manifest-LifecycleInterfaceOperationRefersToImplementationArtifact" -Test {			
			# Arrange

			# Act
			$if = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle'
			
			# Act and Assert
			foreach ($operation in $if.Operation.name) {
				$result = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq $operation;
				$result.operationName | Should Be $operation;
			}
		}
		
		It "Manifest-ImplementationArtifactRefersToArtifactReference" -Test {			
			# Arrange

			# Act
			$if = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact
			
			# Act and Assert
			foreach ($artifactRef in $if.artifactRef) {
				$result = $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq $artifactRef;
				$result.id | Should Be $artifactRef;
			}
		}

		It "Manifest-DeploymentArtifactsRefersToArtifactReference" -Test {			
			# Arrange

			# Act
			$if = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.DeploymentArtifacts
			
			# Act and Assert
			foreach ($artifactRef in $if.artifactRef) {
				$artifactRef | Should Not Be $null;
				$result = $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq $artifactRef;
				$result.id | Should Not Be $null;
				$result.id | Should Be $artifactRef;
			}
		}
		
		It "Manifest-ArtifactReferenceExists" -Test {
			# Arrange

			# Act and Assert
			foreach($artifactReferece in $xml.Definitions.ArtifactReferences.ArtifactReference)
			{
				$artifactReferece.reference | Should Not Be $null;
				[uri] $uriArtifactReferece = $artifactReferece.reference;
				$uriArtifactReferece | Should Not Be $null;
				try
				{
					if($uriArtifactReferece.IsAbsoluteUri)
					{
						$result = Invoke-RestMethod $uriArtifactReferece;
					}
					else
					{
					}
					$result | Should Not Be $null;
				}
				catch
				{
					'URI not found' | Should Be $uriArtifactReferece;
				}
			}
		}
		
		# It "Manifest-" -Test {		
			# # Arrange
			
			# https://gitlab.msp.sharedop.net/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnCreated.bpmn20.xml
			
			# # Act
			# $type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
			
			# # Act and Assert
			# $xml.Definitions.NodeType.type | Should Be $type
			
			# foreach ($operation in $if.Operation.name) {
				# $result = $xml.Definitions.ArtifactReferences.ArtifactReference.Id |? operationName -eq $operation;
				# $result.operationName | Should Be $operation
				# 1 | Should Be 1;
				
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