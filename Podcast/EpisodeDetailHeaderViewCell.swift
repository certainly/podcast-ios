//
//  EpisodeDetailHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeDetailHeaderViewCellDelegate: class {
    func episodeDetailHeaderDidPressPlayButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressMoreButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressRecommendButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressBookmarkButton(cell: EpisodeDetailHeaderViewCell)
}

class EpisodeDetailHeaderViewCell: UITableViewCell {
    var episodeArtworkImageView: ImageView!
    var seriesTitleLabel: UILabel!
    var publisherLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var episodeUtilityButtonBarView: EpisodeUtilityButtonBarView!
    weak var delegate: EpisodeDetailHeaderViewCellDelegate?
    
    let marginSpacing: CGFloat = 18
    let artworkDimension: CGFloat = 79
    
    let seriesTitleLabelXValue: CGFloat = 109
    
    let publisherLabelXValue: CGFloat = 109
    
    let episodeTitleLabelYValue: CGFloat = 117
    
    let dateLabelYSpacing: CGFloat = 6
    let descriptionLabelYSpacing: CGFloat = 15

    let bottomViewYSpacing: CGFloat = 9
    let bottomDescriptionPadding: CGFloat = 10
    var episodeUtilityButtonBarViewHeight: CGFloat = 48

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.colorFromCode(0xfcfcfe)
        selectionStyle = .none
        
        episodeArtworkImageView = ImageView(frame: CGRect(x: marginSpacing,
                                                            y: marginSpacing,
                                                            width: artworkDimension,
                                                            height: artworkDimension))
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UILabel(frame: .zero)
        seriesTitleLabel.font = ._20SemiboldFont()
        seriesTitleLabel.textColor = .offBlack
        addSubview(seriesTitleLabel)
        
        publisherLabel = UILabel(frame: .zero)
        publisherLabel.font = ._14RegularFont()
        publisherLabel.textColor = .slateGrey
        addSubview(publisherLabel)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = ._20SemiboldFont()
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: CGRect(x: marginSpacing, y: 0, width: frame.width - 2 * marginSpacing, height: 0))
        dateLabel.font = ._12RegularFont()
        dateLabel.textColor = .slateGrey
        addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textColor = .offBlack
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        
        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.hasBottomLineseparator = true
        addSubview(episodeUtilityButtonBarView)
    
        episodeUtilityButtonBarView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.recommendedButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        episodeTitleLabel.frame = CGRect(x: marginSpacing, y: episodeTitleLabelYValue, width: frame.width - 2 * marginSpacing, height: 0)
        UILabel.adjustHeightToFit(label: episodeTitleLabel, numberOfLines: 2)
        
        seriesTitleLabel.frame = CGRect(x: seriesTitleLabelXValue,y: marginSpacing, width: frame.width - marginSpacing - seriesTitleLabelXValue, height: 0)
        UILabel.adjustHeightToFit(label: seriesTitleLabel, numberOfLines: 2)
        
        publisherLabel.frame = CGRect(x: publisherLabelXValue,
                                      y: seriesTitleLabel.frame.maxY + marginSpacing / 2,
                                      width: frame.width - marginSpacing - publisherLabelXValue,
                                      height: 0)
        UILabel.adjustHeightToFit(label: publisherLabel)
        
        dateLabel.sizeToFit()
        dateLabel.frame.origin.y = episodeTitleLabel.frame.maxY + dateLabelYSpacing
        
        episodeUtilityButtonBarView.frame = CGRect(x: 0, y: dateLabel.frame.maxY + bottomViewYSpacing, width: frame.width, height: episodeUtilityButtonBarViewHeight)
        
        descriptionLabel.frame = CGRect(x: marginSpacing, y: episodeUtilityButtonBarView.frame.maxY + descriptionLabelYSpacing, width: frame.width - 2 * marginSpacing, height: 0)
        descriptionLabel.sizeToFit()
        
        frame.size.height = descriptionLabel.frame.maxY + bottomDescriptionPadding
    }
    
    func setupForEpisode(episode: Episode) {
        episodeArtworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        seriesTitleLabel.text = episode.seriesTitle
        episodeTitleLabel.text = episode.title
        episodeUtilityButtonBarView.recommendedButton.setupWithNumber(isSelected: episode.isRecommended, numberOf: episode.numberOfRecommendations)
        setBookmarkButtonToState(isBookmarked: episode.isBookmarked)
        dateLabel.text = episode.dateString()
        descriptionLabel.attributedText = episode.attributedDescriptionString()
    }
    
    //
    // Delegate Methods 
    //
    
    func setPlayButtonToState(isPlaying: Bool) {
        episodeUtilityButtonBarView.playButton.isSelected = isPlaying
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        episodeUtilityButtonBarView.bookmarkButton.isSelected = isBookmarked
    }
    
    func setRecommendedButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        
        episodeUtilityButtonBarView.recommendedButton.setupWithNumber(isSelected: isRecommended, numberOf: numberOfRecommendations)
    }
    
    @objc func playButtonTapped() {
        if !episodeUtilityButtonBarView.playButton.isSelected {
            delegate?.episodeDetailHeaderDidPressPlayButton(cell: self)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        delegate?.episodeDetailHeaderDidPressBookmarkButton(cell: self)
    }
    
    @objc func moreButtonTapped() {
        delegate?.episodeDetailHeaderDidPressMoreButton(cell: self)
    }
    
    @objc func recommendButtonTapped() {
        delegate?.episodeDetailHeaderDidPressRecommendButton(cell: self)
    }
}
