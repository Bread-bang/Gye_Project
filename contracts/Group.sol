// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Group {
    enum MemberStatus { Supervisor, Member, NotMember}

    uint private groupIndex = 1;

    mapping(uint => address[]) private groups;                      // (group ID, members)
    mapping(uint => string) private groupNames;                     // (group ID, group name)
    mapping(string => uint) private nameToGroupID;                  // (group name, group ID)
    mapping(address => mapping(uint => uint)) private joinedStatus; // (member, (group ID, member status))

    // Anyone can create a group.
    function createGroup (string memory _name) public {
        require(nameToGroupID[_name] == 0, "Group already exist");

        groups[groupIndex].push(msg.sender);

        groupNames[groupIndex] = _name;

        nameToGroupID[_name] = groupIndex;
        joinedStatus[msg.sender][groupIndex] = uint(MemberStatus.Supervisor);
        groupIndex++;
    }

    /* 
        Read Group Information 
    */
    function readGroupMembersByName (string memory _groupName) public view returns (address[] memory) {
        require(nameToGroupID[_groupName] != 0, "Doesn't exist group");
        uint _groupID = readGroupIdByName(_groupName);
        return groups[_groupID];
    }
    
    function readGroupIdByName (string memory _groupName) private view returns (uint) {
        require(nameToGroupID[_groupName] != 0, "Doesn't exist group");
        return nameToGroupID[_groupName];
    }

    // Update Group Name
    function updateGroupName (string memory _oldName, string memory _newName) public returns (bool) {
        // To check if the group of _oldName or _newName exists
        require(nameToGroupID[_oldName] != 0, "Not found the group");
        require(nameToGroupID[_newName] == 0, "Group name you want already exists");

        // To check if the msg.sender is creator for the group
        uint _groupID = readGroupIdByName(_oldName);
        require(groups[_groupID][0] == msg.sender, "Only group creator can modify the group name");

        delete nameToGroupID[_oldName];

        groupNames[_groupID] = _newName;
        nameToGroupID[_newName] = _groupID;

        return true;
    }

    //  Delete Group Information 
    function deleteGroupByName (string memory _groupName) public {
        require(nameToGroupID[_groupName] != 0, "Doesn't exist group");
        
        uint _groupID = nameToGroupID[_groupName];
        address[] memory _groupMembers = groups[_groupID];

        require(groups[_groupID][0] == msg.sender, "Only group creator can delete the group name");

        delete nameToGroupID[_groupName];
        delete groups[_groupID];
        delete groupNames[_groupID];

        for (uint i = 0; i < _groupMembers.length; i++) {
            delete joinedStatus[_groupMembers[i]][_groupID];
        }
    }

    // Join the group
    function joinGroup (string memory _groupName) public {
        require(nameToGroupID[_groupName] != 0, "Doesn't exist group");

        // If msg.sender already joined the group, it will be rejeted.
        uint _groupID = nameToGroupID[_groupName];
        require(joinedStatus[msg.sender][_groupID] == 0, "Already joined the group");

        // Join
        groups[_groupID].push(msg.sender);
        joinedStatus[msg.sender][_groupID] = uint(MemberStatus.Member);
    }

    // List up the member in the group
    // function listUpMembers (string memory _groupName) public view returns (address[] memory) {
    //     uint memberCount;
    //     uint _groupID = nameToGroupID[_groupName];
    //     address[] memory members = groups[_groupID];
    //     for (uint i = 0; i < members.length; i++) {
    //         // If he is joining in the _groupID, the number of the group member is counted
    //         if (joinedStatus[members[i]][_groupID] != uint(MemberStatus.NotMember)) {
    //             memberCount++;
    //         }
    //     }

    //     uint index;
    //     address[] memory realMembers = new address[](memberCount);
    //     for (uint i = 0; i < members.length; i++) {
    //         if (joinedStatus[members[i]][_groupID] != uint(MemberStatus.NotMember)) {
    //             realMembers[index++] = members[i];
    //         }
    //     }

    //     return realMembers;
    // }
}
