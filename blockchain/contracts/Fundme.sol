// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Fundme {
        struct Campaign{
            address owner;
            string title;
            string description;
            unint256 target;
            unint256 dateline;
            unint256 amountCollected;
            string imagePath;
            address[] donators;
            unint256 donations;
        }
        mapping(unint256 => Campaign) public campaigns;
        unint256 public numberOfCampaigns = 0;

        function createCampaign(address _owner, string memory _title, string memory _description, unint256 _target, unint256 _dateline, string memory _image) public returns(unint256){
            Campaign storage campaign = campaigns[numberOfCampaigns];

            // checking if all is good
            require(campaign.dateline < block.timestamp, "This time has collapsed, choose time in future");
            campaign.owner = _owner;
            campaign.title = _title;
            campaign.description = _description;
            campaign.target = _target;
            campaign.dateline = _dateline;
            campaign.imagePath = _image;
            campaign.amountCollected = 0;

            numberOfCampaigns++;

            return numberOfCampaigns - 1;
        }

        function donateToCampaign(unint256 _id) public payable{
            unint256 amount = msg.value;

            Campaign storage campaign = campaigns[_id];
            campaign.donators.push(msg.sender);
            campaign.donations.push(amount);
            (bool sent,) = payable(campaign.owner).call{value: amount}("");

            if(sent){
                campaign.amountCollected = campaign.amountCollected + amount;
            }
        }

        function getDonators(unint256 _id) view public returns(address[] memory, unint256 [] memory){
            return(campaigns[_id].donators, campaigns[_id].donations)
        }

        function getCampaigns() public view returns(Campaign[] memory){
            Campaign [] memory allCampaigns = new Campaign[](numberOfCampaigns);

            for(unint256 i=0; i<numberOfCampaigns; i++){
                Campaign storage item = campaigns[i];
                allCampaigns[i] = item;
            }
            return allCampaigns;
        }
}