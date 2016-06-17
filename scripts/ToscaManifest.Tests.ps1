#Requires -Modules Microsoft.PowerShell.Management

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

Describe -Tags "Test-ToscaManifest" "Test-ToscaManifest" {

	Mock Export-ModuleMember { return $null; }
	
	. "$here\$sut"
	
	Context "Test-ToscaManifest" {
	
		# Context wide constants
		if(!(Test-Path variable:RepositoryUrl))
		{
			$RepositoryUrl = 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem';
		}
		if(!(Test-Path variable:BranchName))
		{
			$BranchName = 'master';
		}
		
		New-Variable -Name baseUri -Scope Script;
		New-Variable -Name manifestUri -Scope Script;
		New-Variable -Name manifestContent -Scope Script;
		New-Variable -Name xml -Scope Script;
		
		$Manifest = 'TOSCA-Metadata/TOSCA.meta';

		$ToscaInterfaceLifecycleStates = 'biz.dfch.Appclusive.Interfaces.Lifecycle.States';
		$ToscaInterfaceLifecycleTransitions = 'biz.dfch.Appclusive.Interfaces.Lifecycle.Transitions';
		
		It "Warmup" -Test {			
			$explanation = 'This test only exists to mitigate the timing error on the first displayed test result.';
		}

		It "Manifest-IsValidBaseUri" -Test {
			# Arrange
			$_baseUri = '{0}/{1}' -f $RepositoryUrl.Trim('/'), $BranchName.Trim('/');
			
			# Act
			$result = [uri]::IsWellFormedUriString($_baseUri, [System.UriKind]::Absolute);
			
			# Assert
			$result | Should Be $true;
			Set-Variable -Name baseUri -Value (New-Object System.Uri($_baseUri)) -Scope Script;
			$baseUri.IsAbsoluteUri | Should Be $true;
		}
		
		It "Manifest-IsValidManifestUri" -Test {
			# Arrange
			$_manifestUri = '{0}/{1}' -f $baseUri.AbsoluteUri.Trim('/'), $Manifest.Trim('/');

			# Act
			$result = [uri]::IsWellFormedUriString($_manifestUri, [System.UriKind]::Absolute);
			
			# Assert
			$result | Should Be $true;
			Set-Variable -Name manifestUri -Value (New-Object System.Uri($_manifestUri)) -Scope Script;
			$manifestUri.IsAbsoluteUri | Should Be $true;
		}
		
		It "Manifest-IsAvailable" -Test {
			# Arrange
			$_manifestContent = Invoke-RestMethod $manifestUri;

			# Act
			Set-Variable -Name manifestContent -Value $_manifestContent	-Scope Script;
			
			# Assert
			$manifestContent | Should Not Be $null;
		}

		It "Manifest-ContainsDefinitions" -Test {
			# Arrange
			# use this regex to extract the definitions from a tosca manifest
			$regex = '(?m)(^Name:\ (.+)$\n^Content-Type:\ (.+)$)';
			# match will look like this
			# $Matches
			# Name Value
			# ---- -----
			# 3    application/vnd.oasis.tosca.definitions
			# 2    definitions/tosca-definitions.xml
			# 1    Name: definitions/tosca-definitions.xml
			# 0    Name: definitions/tosca-definitions.xml
			
			# Act
			$isMatch = $manifestContent -match $regex;
			
			# Assert
			$isMatch | Should Be $true;
			$Matches.Count | Should Be 4;
			
			$_xml = Invoke-RestMethod ('{0}/{1}' -f $baseUri, $Matches[2]);
			Set-Variable -Name xml -Value $_xml	-Scope Script;
			
			$xml | Should Not Be $null;
		}
		
		It "Manifest-IsValidXmlDocument" -Test {
			# Arrange

			# Act
			
			# Assert
			$xml -is [System.Xml.XmlDocument] | Should Be $true;
		}

		It "Manifest-HasDefinitionsElement" -Test {
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
		
		It "Manifest-HasLifecycleInterfaceForTransitions" -Test {			
			# Arrange

			# Act
			$lifecycleInterface = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq $ToscaInterfaceLifecycleTransitions;
			
			# Assert
			$lifecycleInterface | Should Not Be $null;
		}

		It "Manifest-HasLifecycleInterfaceForStates" -Test {			
			# Arrange

			# Act
			$lifecycleInterface = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq $ToscaInterfaceLifecycleStates;
			
			# Assert
			$lifecycleInterface | Should Not Be $null;
		}

		It "Manifest-NodeTemplateRefersToNodeType" -Test {
			# Arrange
			
			# Act
			$type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
			
			# Assert
			$xml.Definitions.NodeType.type | Should Be $type;
		}
		
		It "Manifest-NodeTypeContainsInterfaces" -Test {
			# Arrange
			
			# Act
			$nodeType = $xml.Definitions.NodeType;
			
			# Act and Assert
			foreach ($NodeTypeName in $nodeType.type) {
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
			$interface = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle';
			
			# Act and Assert
			foreach ($operation in $interface.Operation.name) {
				$result = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq $operation;
				$result.operationName | Should Be $operation;
			}
		}
		
		It "Manifest-ImplementationArtifactRefersToArtifactReference" -Test {			
			# Arrange

			# Act
			$interface = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact
			
			# Act and Assert
			foreach ($artifactRef in $interface.artifactRef) {
				$result = $xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq $artifactRef;
				$result.id | Should Be $artifactRef;
			}
		}

		It "Manifest-DeploymentArtifactsRefersToArtifactReference" -Test {			
			# Arrange

			# Act
			$interface = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.DeploymentArtifacts
			
			# Act and Assert
			foreach ($artifactRef in $interface.artifactRef) {
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
				[uri] $uriArtifactReference = $artifactReferece.reference;
				$uriArtifactReference | Should Not Be $null;
				try
				{
					if($uriArtifactReference.IsAbsoluteUri)
					{
						$result = Invoke-RestMethod $uriArtifactReference;
					}
					else
					{
						$result = Invoke-RestMethod ("{0}/{1}" -f (Get-Variable -Name baseUri -ValueOnly).AbsoluteUri, $uriArtifactReference.OriginalString);
					}
					$result | Should Not Be $null;
				}
				catch
				{
					'URI not found' | Should Be $uriArtifactReference;
				}
			}
		}
	}
}
