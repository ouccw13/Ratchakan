//
//  ReadNoteViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 25/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import ScreenShield
class ReadNoteViewController: CustomUIViewControllerNoNavNoTabbar {
    
    var viewModel: ReadNoteViewModel!
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        return button
    }()
    
    private let backButtonArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clearCanTouch
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitReg16
        label.textColor = .white
        return label
    }()
    
    private let topGradient:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "readNoteTopGradient"))
        iv.backgroundColor = .clearCanTouch
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let bottomGradient:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "readNoteBottomGradient"))
        iv.backgroundColor = .clearCanTouch
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitReg12
        label.textColor = .white
        return label
    }()
    
    private var noteCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var previewCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private var didPageZoomed: Bool = false
    private var doesNoteScrollByUser: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.callNoteDetail {
            self.setupUI()
        }
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionView()
        
        ScreenShield.shared.protect(view: view)
        ScreenShield.shared.protectFromScreenRecording()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenShot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if #available(iOS 11.0, *) {
            if keyPath == "captured" {
                let isCaptured = UIScreen.main.isCaptured
                if isCaptured {
                    handleScreenShot()
                }
            }
        }
    }
    
    private func setupCollectionView() {
        let noteLayout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.scrollDirection = .horizontal
            return lo
        }()
        
        noteCollectionView.collectionViewLayout = noteLayout
        
        noteCollectionView.dataSource = self
        noteCollectionView.delegate = self
        noteCollectionView.isPagingEnabled = true
        noteCollectionView.bounces = false
        if #available(iOS 10.0, *) {
            noteCollectionView.isPrefetchingEnabled = false
        }
        noteCollectionView.hideScrollIndicatior()
        noteCollectionView.register(NotePageCollectionViewCell.self, forCellWithReuseIdentifier: NotePageCollectionViewCell.identifier)
        
        let previewLayout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.scrollDirection = .horizontal
            return lo
        }()
        
        previewCollectionView.collectionViewLayout = previewLayout
        
        previewCollectionView.backgroundColor = .clear
        previewCollectionView.dataSource = self
        previewCollectionView.delegate = self
        previewCollectionView.layer.masksToBounds = false
        if #available(iOS 10.0, *) {
            previewCollectionView.isPrefetchingEnabled = false
        }
        previewCollectionView.hideScrollIndicatior()
        previewCollectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        
        previewCollectionView.selectItem(at: viewModel.selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        noteCollectionView.scrollToItem(at: viewModel.selectedIndexPath, at: .centeredHorizontally, animated: false)
        
    }
    
    private func setupUI() {
        view.addSubview(noteCollectionView)
        noteCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        view.addSubview(topGradient)
        topGradient.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(148)
        }
        
        view.addSubview(bottomGradient)
        bottomGradient.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(200)
        }
        
        let topView = UIView()
        topView.backgroundColor = .clear
        
        topGradient.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.height.equalTo(TOP_VIEW)
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        topGradient.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(topView.snp.leading).offset(16)
            make.bottom.equalTo(topView.snp.bottom).offset(-16)
        }
        
        topGradient.addSubview(backButtonArea)
        backButtonArea.snp.makeConstraints { (make) in
            make.leading.equalTo(backButton.snp.leading).offset(-6)
            make.centerY.equalTo(backButton.snp.centerY)
            make.size.equalTo(50)
        }
        backButtonArea.addTarget(self, selector: #selector(backButtonDidTap))
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(36)
            make.trailing.equalTo(view.snp.trailing).offset(-36)
        }
        titleLabel.text = viewModel.titleText
        
        bottomGradient.addSubview(previewCollectionView)
        previewCollectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomGradient.snp.bottom).offset(-48)
            make.leading.equalTo(bottomGradient.snp.leading)
            make.trailing.equalTo(bottomGradient.snp.trailing)
            make.height.equalTo(IS_IPAD ? 226 : 86)
        }
        
        bottomGradient.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomGradient.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-18)
        }
        
        updatePageLabel(viewModel.selectedIndexPath)
    }
    
    // MARK: SETUP TAP GESTURE
    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        self.noteCollectionView.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.noteCollectionView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }
    
    // hide top and bottom view when single tapping
    @objc private func handleSingleTap() {
        if topGradient.isHidden {
            topGradient.isHidden = false
            bottomGradient.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.topGradient.alpha = 1
                self.bottomGradient.alpha = 1
                self.didPageZoomed = false
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.topGradient.alpha = 0
                self.bottomGradient.alpha = 0
            }) { (_ ) in
                self.topGradient.isHidden = true
                self.bottomGradient.isHidden = true
            }
        }
    }
    
    // for zoom into tapped position
    @objc private func handleDoubleTap(sender: UITapGestureRecognizer) {
        
        for cell in noteCollectionView.visibleCells {
            let cell = cell as! NotePageCollectionViewCell
            if cell.noteImage.isPreview {
                let scrollView = cell.scrollView
                print("Zoom scale: \(scrollView.zoomScale)")
                if scrollView.zoomScale == 1.0 {
                    scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view), item: scrollView), animated: true)
                } else {
                    scrollView.setZoomScale(1.0, animated: true)
                }
            }
        }
        
    }
    
    // get tapped position
    private func zoomRectForScale(scale: CGFloat, center: CGPoint, item: UIView) -> CGRect {
        
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = view.frame.size.height / scale
        zoomRect.size.width = view.frame.size.width / scale
        
        let newCenter = view.convert(center, to: item)
        
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    // prevent user from taking screenshot
    @objc private func handleScreenShot() {
        let alert = UIAlertController(title: "คำเตือน", message: "ไม่อนุญาตให้มีการบันทึกภาพหน้าจอ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true)
    }
    
    private func updatePageLabel(_ indexPath: IndexPath) {
        let totalPage = viewModel.note.noteImages!.count
        let page = indexPath.row + 1
        pageLabel.text = "\(page)/\(totalPage)"
    }
    
    @objc private func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - HANDLE COLLECTIONVIEW
extension ReadNoteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfImage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == noteCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotePageCollectionViewCell.identifier, for: indexPath) as! NotePageCollectionViewCell
            cell.isMyNote = viewModel.note.isMyNote
            cell.noteImage = viewModel.getData(atIndexPath: indexPath)
            cell.whenScrollViewZoomed = {
                if !self.didPageZoomed {
                    self.handleSingleTap()
                    self.didPageZoomed = true
                }
            }
            return cell
        } else if collectionView == previewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.identifier, for: indexPath) as! PreviewCollectionViewCell
            cell.isMyNote = viewModel.note.isMyNote
            cell.noteImage = viewModel.getData(atIndexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == noteCollectionView {
            guard let cell = cell as? NotePageCollectionViewCell else {
                fatalError("The cell is not an instance of \(NotePageCollectionViewCell.identifier).")
            }
            cell.scrollView.zoomScale = 1.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == previewCollectionView {
            
            doesNoteScrollByUser = false
            
            previewCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            noteCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
            updatePageLabel(indexPath)
            
        }
        
    }
    
    // MARK: - SCROLLVIEW
    // handle scrollview to scroll synchronizely
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if let collectionView = scrollView as? UICollectionView {
            if collectionView == noteCollectionView {

                let point = view.convert(noteCollectionView.center, to: noteCollectionView)
                
                guard let indexPath = noteCollectionView.indexPathForItem(at: point) else { return }
                if doesNoteScrollByUser {
                
                    let scrollingPercent = (scrollView.contentOffset.x / SCREEN_WIDTH) * 100
                    let scale: CGFloat = IS_IPAD ? 168 : 74
                        
                    previewCollectionView.contentOffset.x = ((scrollingPercent/100) * scale)
                        
                    previewCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                
                    updatePageLabel(indexPath)
                }
                
                
            } else if collectionView == previewCollectionView {
                let point = bottomGradient.convert(previewCollectionView.center, to: previewCollectionView)
                
                guard let indexPath = previewCollectionView.indexPathForItem(at: point) else { return }
                
                if collectionView.panGestureRecognizer.state == .changed {
                    
                    previewCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
                    noteCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    updatePageLabel(indexPath)
                    
                } else if collectionView.panGestureRecognizer.state == .possible {
                    previewCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
                    updatePageLabel(indexPath)
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == previewCollectionView {
            doesNoteScrollByUser = false
        } else if scrollView == noteCollectionView {
            doesNoteScrollByUser = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let point = view.convert(noteCollectionView.center, to: noteCollectionView)
        
        guard let indexPath = noteCollectionView.indexPathForItem(at: point) else { return }
        
        previewCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        updatePageLabel(indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let collectionView = scrollView as? UICollectionView {
            if collectionView == previewCollectionView {
                
                let indexPath = previewCollectionView.indexPathsForSelectedItems![0]
                noteCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                previewCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                updatePageLabel(indexPath)
                                
            } else if collectionView == noteCollectionView {
                
                let point = view.convert(noteCollectionView.center, to: noteCollectionView)
                
                guard let indexPath = noteCollectionView.indexPathForItem(at: point) else { return }
                
                noteCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                previewCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
}

extension ReadNoteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == noteCollectionView {
            return 0
        } else if collectionView == previewCollectionView {
            return 12
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == noteCollectionView {
            return 0
        } else if collectionView == previewCollectionView {
            return 10
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == noteCollectionView {
            return .init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        } else if collectionView == previewCollectionView {
            let width:CGFloat = IS_IPAD ? 156 : 64
            let height:CGFloat = IS_IPAD ? 226 : 86
            return .init(width: width, height: height)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == noteCollectionView {
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        } else if collectionView == previewCollectionView {
            let width:CGFloat = IS_IPAD ? 156 : 64
            return .init(top: 0, left: (SCREEN_WIDTH / 2) - (width / 2), bottom: 0, right: (SCREEN_WIDTH / 2) - (width / 2))
        }
        return UIEdgeInsets()
    }
    
}
